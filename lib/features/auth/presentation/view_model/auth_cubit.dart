import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/auth/data/models/sign_in_request_model.dart';
import 'package:e_commeric/features/auth/data/models/sign_up_request_model.dart';
import 'package:e_commeric/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commeric/features/auth/presentation/view_model/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial());

  final AuthRepository _repository;

  Future<void> signIn(SignInRequestModel request) async {
    emit(LoginLoading());
    try {
      final response = await _repository.signIn(request);
      emit(LoginSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(LoginFailure(errorMessage: error.message));
    } catch (_) {
      emit(LoginFailure(errorMessage: AppStrings.unableToSignInPleaseTryAgain));
    }
  }

  Future<void> signUp(SignUpRequestModel request) async {
    emit(SignUpLoading());
    try {
      final response = await _repository.signUp(request);
      emit(SignUpSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(SignUpFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        SignUpFailure(
          errorMessage: AppStrings.unableToCreateYourAccountPleaseTryAgain,
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await _repository.signOut();
      emit(SignOutSuccess(message: AppStrings.signedOutSuccessfully));
    } catch (_) {
      emit(SignOutFailure(errorMessage: AppStrings.unableToSignOut));
    }
  }
}
