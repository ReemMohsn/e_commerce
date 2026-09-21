import 'package:e_commeric/features/profile/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileEmpty extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({required this.user});
  final UserModel user;
}

class EditProfileSuccess extends ProfileState {
  EditProfileSuccess({required this.message});
  final String message;
}

class ProfileFailure extends ProfileState {
  ProfileFailure({required this.errorMessage});
  final String errorMessage;
}
