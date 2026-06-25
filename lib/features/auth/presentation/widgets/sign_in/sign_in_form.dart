import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:fit_check/features/auth/presentation/bloc/login/login_event.dart';
import 'package:fit_check/features/auth/presentation/bloc/login/login_state.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/auth_text_field.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/primary_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          label: 'Email Address',
          hintText: 'Enter your email address',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20.h),
        AuthTextField(
          label: 'Password',
          hintText: '••••••••',
          isPassword: true,
          controller: _passwordController,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password',
                style: AppTextStyles.labelMedium().copyWith(
                  color: AppColors.wardroRedText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Successful!')),
              );
              context.go('/home');
            } else if (state is LoginError) {
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
              text: 'Sign In',
              isLoading: state is LoginLoading,
              backgroundColor: AppColors.wardroBrown,
              onPressed: () {
                context.read<LoginBloc>().add(
                  LoginSubmitted(
                    email: _emailController.text,
                    password: _passwordController.text,
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
