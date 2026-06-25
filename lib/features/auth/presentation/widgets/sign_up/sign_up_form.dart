import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_event.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_state.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/auth_text_field.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/primary_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          label: 'Full Name',
          hintText: 'Jane Doe',
          controller: _nameController,
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          label: 'Email Address',
          hintText: 'jane@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          label: 'Phone Number',
          hintText: '+1 (555) 000-0000',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          label: 'Password',
          hintText: '••••••••',
          isPassword: true,
          controller: _passwordController,
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          label: 'Confirm Password',
          hintText: '••••••••',
          isPassword: true,
          controller: _confirmPasswordController,
        ),
        SizedBox(height: 32.h),
        BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration Successful!')),
              );
              // Navigate back to login
              context.pop();
            } else if (state is RegisterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              text: 'Đăng ký',
              isLoading: state is RegisterLoading,
              backgroundColor: AppColors.wardroBrown,
              onPressed: () {
                context.read<RegisterBloc>().add(
                  RegisterSubmitted(
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
