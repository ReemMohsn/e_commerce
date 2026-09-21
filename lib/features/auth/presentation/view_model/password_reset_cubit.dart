import 'package:e_commeric/core/constants/app_strings.dart';
import 'dart:async';

import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/auth/data/models/reset_password_request_model.dart';
import 'package:e_commeric/features/auth/data/models/verify_code_request_model.dart';
import 'package:e_commeric/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commeric/features/auth/presentation/view_model/password_reset_state.dart';
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
              AppStrings.unableToSendTheVerificationCodePleaseTryAgain,
        ),
      );
    }
  }

  Future<void> verifyCode(VerifyCodeRequestModel request) async {
    emit(VerifyCodeLoading());
    try {
      final response = await _repository.activatePasswordReset(request);
      emit(VerifyCodeSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(VerifyCodeFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        VerifyCodeFailure(
          errorMessage: AppStrings.unableToVerifyTheCodePleaseTryAgain,
        ),
      );
    }
  }

  Future<void> resendCode({required String email}) async {
    if (_secondsRemaining > 0) return;
    await requestCode(email: email);
    if (state is SendCodeSuccess) startTimer();
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

  Future<void> resetPassword(ResetPasswordRequestModel request) async {
    emit(ResetPasswordLoading());
    try {
      final response = await _repository.resetPassword(request);
      emit(ResetPasswordSuccess(message: response.message));
    } on ServerException catch (error) {
      emit(ResetPasswordFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        ResetPasswordFailure(
          errorMessage: AppStrings.unableToUpdateThePasswordPleaseTryAgain,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
