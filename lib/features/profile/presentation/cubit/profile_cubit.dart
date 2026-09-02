import 'package:e_commeric/core/services/errors/cache_exception.dart';
import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/profile/data/models/user_model.dart';
import 'package:e_commeric/features/profile/data/repositories/profile_repository.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(ProfileInitial());

  final ProfileRepository _repository;

  Future<void> getCurrentUser() async {
    emit(ProfileLoading());

    try {
      final user = await _repository.getCurrentUser();

      if (user == null) {
        emit(ProfileEmpty());
      } else {
        emit(ProfileSuccess(user: user));
      }
    } on CacheException catch (error) {
      emit(ProfileFailure(errorMessage: error.message));
    } catch (error) {
      emit(ProfileFailure(errorMessage: 'An unexpected error occurred.'));
    }
  }

  Future<void> editProfile({required UserModel userModel}) async {
    emit(ProfileLoading());
    try {
      final response = await _repository.editProfile(userModel: userModel);
      emit(EditProfileSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(ProfileFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        ProfileFailure(
          errorMessage: 'Unable to create your account. Please try again.',
        ),
      );
    }
  }
}
