import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/social_button.dart';
import '../widgets/sign_in/sign_in_header.dart';
import '../widgets/sign_in/sign_in_form.dart';
import 'package:fit_check/core/di/injection_container.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SignInHeader(),
                  const SignInForm(),
                  SizedBox(height: 10.h),
                  Text('Or', style: AppTextStyles.bodySmall()),
                  SizedBox(height: 10.h),
                  SocialButton(
                    text: 'Continue with Google',
                    icon: Icon(
                      Icons.g_mobiledata,
                      size: 32.sp,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.titleSmall2().copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
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
      ),
    );
  }
}
