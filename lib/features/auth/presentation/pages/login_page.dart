import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            context.showSnackBar(
              state.errorMessage ?? 'auth.email_invalid'.tr(),
              isError: true,
            );
          } else if (state.status == AuthStatus.authenticated) {
            context.showSnackBar('auth.login_success'.tr());
            context.go(RouteNames.home);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;

          return Center(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.space24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo Icon
                    Icon(
                      Icons.flutter_dash,
                      size: 80.w,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: AppDimensions.space16.h),

                    // App Title
                    Text(
                      'app_name'.tr(),
                      style: AppTypography.heading1.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.space8.h),
                    Text(
                      'home.subtitle'.tr(),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.space32.h),

                    // Email Field
                    AppTextField(
                      controller: _emailController,
                      labelText: 'auth.email'.tr(),
                      hintText: 'auth.email_hint'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: AppValidators.email,
                    ),
                    SizedBox(height: AppDimensions.space16.h),

                    // Password Field
                    AppTextField(
                      controller: _passwordController,
                      labelText: 'auth.password'.tr(),
                      hintText: 'auth.password_hint'.tr(),
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (v) => AppValidators.password(v, minLength: 6),
                      onSubmitted: (_) => _onLoginPressed(),
                    ),
                    SizedBox(height: AppDimensions.space24.h),

                    // Submit Button
                    AppButton(
                      text: 'auth.login'.tr(),
                      isLoading: isLoading,
                      onPressed: _onLoginPressed,
                    ),
                    SizedBox(height: AppDimensions.space16.h),

                    // Bypass to Home for demo
                    AppButton.outline(
                      text: 'Xem Showcase Không Cần Login',
                      onPressed: () => context.go(RouteNames.home),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
