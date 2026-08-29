import 'dart:async';

import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commeric/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._repository) : super(PasswordResetInitial());

  final AuthRepository _repository;
  Timer? _timer;
  int _secondsRemaining = 46;

  Future<void> requestCode({required String email}) async {
    emit(SendCodeLoading());
    try {
      final response = await _repository.requestPasswordResetCode(email);
      emit(SendCodeSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(SendCodeFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        SendCodeFailure(
          errorMessage:
              'Unable to send the verification code. Please try again.',
        ),
      );
    }
  }

  Future<void> verifyCode({required String email, required String code}) async {
    emit(VerifyCodeLoading());
    try {
      final response = await _repository.activatePasswordReset(
        email: email,
        code: code,
      );
      emit(VerifyCodeSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(VerifyCodeFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        VerifyCodeFailure(
          errorMessage: 'Unable to verify the code. Please try again.',
        ),
      );
    }
  }

  Future<void> resendCode({required String email}) async {
    if (_secondsRemaining > 0) return;
    await requestCode(email: email);
    if (state is SendCodeSuccess) startTimer();
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final response = await _repository.resetPassword(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      await _repository.clearResetData();
      emit(ResetPasswordSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(ResetPasswordFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        ResetPasswordFailure(
          errorMessage: 'Unable to update the password. Please try again.',
        ),
      );
    }
  }

  void startTimer({int seconds = 46}) {
    _timer?.cancel();
    _secondsRemaining = seconds;
    emit(ResetCodeTimerUpdated(secondsRemaining: _secondsRemaining));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        return;
      }

      _secondsRemaining--;
      emit(ResetCodeTimerUpdated(secondsRemaining: _secondsRemaining));

      if (_secondsRemaining == 0) timer.cancel();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
