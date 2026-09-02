import 'package:e_commeric/core/common/utils/app_validator.dart';
import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/extensions/screen_context_extension.dart';
import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_back_button.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/phone_text_field.dart';
import 'package:e_commeric/features/profile/data/models/user_model.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _optionalValue(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? null : trimmedValue;
  }

  String? _validateOptionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return AppValidator.phone(value);
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ProfileCubit>().editProfile(
      userModel: UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _optionalValue(_phoneController.text),
        image: widget.user.image,
        address: _optionalValue(_addressController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          context.showLoadingDialog();
        } else if (state is EditProfileSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showSuccessSnackBar(state.message);
          Navigator.of(context).pop();
        } else if (state is ProfileFailure) {
          Navigator.of(context, rootNavigator: true).pop();
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          centerTitle: true,
          leadingWidth: 76,
          leading: const Padding(
            padding: EdgeInsets.only(left: 14, top: 12, bottom: 12),
            child: AuthBackButton(),
          ),
          title: Text(
            'Edit Profile',
            style: context.theme.textTheme.headlineSmall,
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              22,
              20,
              22,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Semantics(
                            label: 'Profile photo',
                            image: true,
                            child: SizedBox.square(
                              dimension: 104,
                              child: ClipOval(
                                child: AppNetworkImage(
                                  imageUrl: widget.user.image,
                                  fallbackIcon: Icons.person_rounded,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Update your personal information below.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
                        AuthTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'Your full name',
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              AppValidator.requiredField(value, field: 'Name'),
                          autofillHints: const [AutofillHints.name],
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AuthTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'You@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: AppValidator.email,
                          autofillHints: const [AutofillHints.email],
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PhoneTextField(
                          controller: _phoneController,
                          validator: _validateOptionalPhone,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),
                        AuthTextField(
                          controller: _addressController,
                          labelText: 'Address',
                          hintText: 'Your address',
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [
                            AutofillHints.fullStreetAddress,
                          ],
                          onFieldSubmitted: (_) => _saveProfile(),
                          prefixIcon: const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
