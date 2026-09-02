import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commeric/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial());

  final AuthRepository _repository;

  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final response = await _repository.signIn(
        email: email,
        password: password,
      );
      emit(LoginSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(LoginFailure(errorMessage: error.message));
    } catch (_) {
      emit(LoginFailure(errorMessage: 'Unable to sign in. Please try again.'));
    }
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(SignUpLoading());
    try {
      final response = await _repository.signUp(
        name: name,
        phone: phone,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(SignUpSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(SignUpFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        SignUpFailure(
          errorMessage: 'Unable to create your account. Please try again.',
        ),
      );
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await _repository.signOut();
      emit(SignOutSuccess(message: 'Signed out successfully'));
    } catch (_) {
      emit(SignOutFailure(errorMessage: 'Unable to sign out.'));
    }
  }
}
