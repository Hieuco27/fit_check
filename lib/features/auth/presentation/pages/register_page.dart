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
      body: Container(
        height: double.infinity,
        color: const Color(0xFFFAF8FB), // Very light purple/pink background
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    gradient: AppGradients.registerButton,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonGradientEndRegister.withOpacity(
                          0.3,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Create Account',
                  style: AppTextStyles.headlineLarge().copyWith(
                    color: const Color(0xFF1F1F2C),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                AuthTextField(
                  label: 'Full Name',
                  hintText: 'Jane Doe',
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                ),
                SizedBox(height: 10.h),
                AuthTextField(
                  label: 'Email Address',
                  hintText: 'jane@example.com',
                  prefixIcon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),
                AuthTextField(
                  label: 'Phone Number',
                  hintText: '+1 (555) 000-0000',
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10.h),
                AuthTextField(
                  label: 'New Password',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),
                SizedBox(height: 10.h),
                AuthTextField(
                  label: 'Confirm Password',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_reset_outlined,
                  isPassword: true,
                  controller: _confirmPasswordController,
                ),
                SizedBox(height: 16.h),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful!'),
                        ),
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
                      text: 'Create Account',
                      isLoading: state is RegisterLoading,
                      gradient: AppGradients.registerButton,
                      trailingIcon: const Icon(
                        Icons.spa_outlined,
                        color: Colors.white,
                      ),
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
                SizedBox(height: 16.h),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.textFieldBorder),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'OR',
                        style: AppTextStyles.labelMedium().copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.textFieldBorder),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SocialButton(onPressed: () {}),
                SizedBox(height: 16.h),
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
                          color: AppColors.brandPurple,
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
      ),
    );
  }
}
