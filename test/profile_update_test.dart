import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/constants/shared_preferences_keys.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/errors/errormodel.dart';
import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_back_button.dart';
import 'package:e_commeric/features/cart/data/repositories/cart_repository.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commeric/features/home/data/repositories/home_repository.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/views/home_view.dart';
import 'package:e_commeric/features/profile/data/models/user_model.dart';
import 'package:e_commeric/features/profile/data/repositories/profile_repository.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:e_commeric/features/profile/presentation/views/edit_profile_view.dart';
import 'package:e_commeric/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _oldUser = UserModel(
  name: 'Old Name',
  email: 'old@example.com',
  phone: '771234567',
  address: 'Old address',
);
const _updatedUser = UserModel(name: 'New Name', email: 'new@example.com');

void main() {
  late _MemoryPreferences storage;
  late SharedPreferencesService preferences;
  late _ProfileApi api;
  late ProfileRepository repository;

  setUp(() async {
    storage = _MemoryPreferences();
    preferences = SharedPreferencesService(preferences: storage);
    api = _ProfileApi();
    repository = ProfileRepository(
      apiService: api,
      preferencesService: preferences,
    );
    await preferences.saveSession(
      token: 'test-token',
      profile: {'_id': 'test-user', ..._oldUser.toJson()},
    );
  });

  test(
    'a message-only success persists edits and cleared optional fields',
    () async {
      final response = await repository.editProfile(userModel: _updatedUser);

      expect(response.message, 'User data updated successfuly');
      expect(api.requests.single, _updatedUser.toJson());
      expect(
        (await repository.getCurrentUser())?.toJson(),
        _updatedUser.toJson(),
      );
      expect((await preferences.profile)?['_id'], 'test-user');
      expect(await preferences.accessToken, 'test-token');
      expect(await preferences.isLoggedIn, isTrue);
    },
  );

  test('a rejected edit preserves the previously saved profile', () async {
    final failingRepository = ProfileRepository(
      apiService: _ProfileApi(
        error: const ServerException(
          ErrorModel(statusCode: 400, message: 'Email is already in use.'),
        ),
      ),
      preferencesService: preferences,
    );
    final cubit = ProfileCubit(failingRepository);
    addTearDown(cubit.close);

    await cubit.editProfile(userModel: _updatedUser);

    expect(cubit.state, isA<ProfileFailure>());
    expect(
      (cubit.state as ProfileFailure).errorMessage,
      'Email is already in use.',
    );
    expect((await repository.getCurrentUser())?.toJson(), _oldUser.toJson());
  });

  test('edit success waits for the local write to finish', () async {
    final writeStarted = Completer<void>();
    final allowWrite = Completer<void>();
    final delayedStorage = _MemoryPreferences(
      beforeProfileWrite: () async {
        writeStarted.complete();
        await allowWrite.future;
      },
    );
    delayedStorage.values.addAll(storage.values);
    final cubit = ProfileCubit(
      ProfileRepository(
        apiService: api,
        preferencesService: SharedPreferencesService(
          preferences: delayedStorage,
        ),
      ),
    );
    addTearDown(cubit.close);

    final saving = cubit.editProfile(userModel: _updatedUser);
    await writeStarted.future;
    expect(cubit.state, isA<ProfileLoading>());

    allowWrite.complete();
    await saving;
    expect(cubit.state, isA<EditProfileSuccess>());
    await cubit.getCurrentUser();
    expect(
      (cubit.state as ProfileSuccess).user.toJson(),
      _updatedUser.toJson(),
    );
  });

  test(
    'a cache write failure explains that the server edit succeeded',
    () async {
      final failingStorage = _MemoryPreferences(
        beforeProfileWrite: () async =>
            throw PlatformException(code: 'write_failed'),
      );
      failingStorage.values.addAll(storage.values);
      final cubit = ProfileCubit(
        ProfileRepository(
          apiService: api,
          preferencesService: SharedPreferencesService(
            preferences: failingStorage,
          ),
        ),
      );
      addTearDown(cubit.close);

      await cubit.editProfile(userModel: _updatedUser);

      expect(api.requests, hasLength(1));
      expect(cubit.state, isA<ProfileFailure>());
      expect(
        (cubit.state as ProfileFailure).errorMessage,
        contains(
          'Your profile was updated, but could not be saved on this device.',
        ),
      );
    },
  );

  test('an edit can populate a missing profile cache', () async {
    storage.values.remove(SharedPreferencesKeys.profile);

    await repository.editProfile(userModel: _updatedUser);

    expect(
      (await repository.getCurrentUser())?.toJson(),
      _updatedUser.toJson(),
    );
  });

  testWidgets(
    'saving and returning updates Profile, Home and the reopened form',
    (tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ProfileCubit(repository)..getCurrentUser(),
              ),
              BlocProvider(
                create: (_) =>
                    _LoadedHomeCubit(HomeRepository(apiService: api)),
              ),
              BlocProvider(
                create: (_) => CartCubit(CartRepository(apiService: api)),
              ),
            ],
            child: const HomeView(),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == AppRoute.profile) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => BlocProvider(
                  create: (_) => ProfileCubit(repository)..getCurrentUser(),
                  child: const ProfileView(),
                ),
              );
            }
            if (settings.name == AppRoute.editProfile) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (_) => BlocProvider(
                  create: (_) => ProfileCubit(repository),
                  child: EditProfileView(
                    user: settings.arguments! as UserModel,
                  ),
                ),
              );
            }
            return null;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hi Old Name!'), findsOneWidget);

      await tester.tap(find.byTooltip('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'New Name',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'new@example.com',
      );
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileView), findsNothing);
      expect(find.text('New Name'), findsOneWidget);
      expect(find.text('new@example.com'), findsOneWidget);

      await tester.tap(find.byType(AuthBackButton));
      await tester.pumpAndSettle();
      expect(find.text('Hi New Name!'), findsOneWidget);
      expect(find.text('Hi Old Name!'), findsNothing);

      await tester.tap(find.byTooltip('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();
      final nameField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Full Name'),
      );
      expect(nameField.controller?.text, 'New Name');

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Unsaved Name',
      );
      await tester.tap(find.byType(AuthBackButton));
      await tester.pumpAndSettle();
      expect(find.text('New Name'), findsOneWidget);
      expect(find.text('Unsaved Name'), findsNothing);
      expect(api.requests, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );
}

class _MemoryPreferences extends Fake implements SharedPreferencesAsync {
  _MemoryPreferences({this.beforeProfileWrite});

  final Map<String, Object> values = {};
  final Future<void> Function()? beforeProfileWrite;

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<void> setString(String key, String value) async {
    if (key == SharedPreferencesKeys.profile) {
      await beforeProfileWrite?.call();
      // Ensure the test stores a serialized profile, just like the platform.
      jsonDecode(value);
    }
    values[key] = value;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    values[key] = value;
  }
}

class _ProfileApi extends Fake implements ApiService {
  _ProfileApi({this.error});

  final Object? error;
  final List<Object?> requests = [];

  @override
  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    expect(path, ApiEndPoints.editProfile);
    requests.add(data);
    if (error != null) throw error!;
    return Response<dynamic>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'message': 'User data updated successfuly'},
    );
  }
}

class _LoadedHomeCubit extends HomeCubit {
  _LoadedHomeCubit(super.repository) {
    emit(
      const HomeState(
        categoriesStatus: HomeRequestStatus.success,
        productsStatus: HomeRequestStatus.success,
        brandsStatus: HomeRequestStatus.success,
      ),
    );
  }
}
