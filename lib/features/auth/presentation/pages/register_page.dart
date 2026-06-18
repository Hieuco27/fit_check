import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/theme/app_theme.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_event.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_state.dart';
import 'package:fit_check/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:fit_check/features/auth/presentation/widgets/primary_button.dart';
import 'package:fit_check/features/auth/presentation/widgets/social_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLarge().copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                ),
              ),

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
              SizedBox(height: 24.h),
              SocialButton(
                text: 'Continue with Google',
                icon: Icon(Icons.g_mobiledata, size: 32.sp, color: Colors.blue),
                onPressed: () {},
              ),
              SizedBox(height: 16.h),
              // SocialButton(
              //   text: 'Continue with Apple',
              //   icon: Icon(Icons.apple, size: 28.sp, color: Colors.black),
              //   onPressed: () {},
              // ),
              // SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.bodySmall().copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(); // Go back to login
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.titleSmall().copyWith(
                        color: AppColors.wardroBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
