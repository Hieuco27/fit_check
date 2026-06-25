import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/social_button.dart';
import '../widgets/sign_up/sign_up_header.dart';
import '../widgets/sign_up/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SignUpHeader(),
                const SignUpForm(),
                SizedBox(height: 10.h),
                Text('Or', style: AppTextStyles.bodySmall()),
                SizedBox(height: 10.h),
                SocialButton(
                  text: 'Continue with Google',
                  icon: Icon(Icons.g_mobiledata, size: 32.sp, color: Colors.blue),
                  onPressed: () {},
                ),
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
      ),
    );
  }
}
