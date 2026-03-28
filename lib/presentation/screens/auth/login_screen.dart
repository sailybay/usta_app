import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/locale/locale_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showForgotPasswordDialog(AppLocalizations l10n) {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loginResetPassword),
        content: TextField(
          controller: resetController,
          decoration: InputDecoration(
            labelText: l10n.authEmailLabel,
            hintText: l10n.loginEnterEmail,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.authCancel),
          ),
          TextButton(
            onPressed: () {
              final email = resetController.text.trim();
              if (email.isNotEmpty && email.contains('@')) {
                Navigator.pop(ctx);
                context.read<AuthBloc>().add(
                  AuthPasswordResetRequested(email: email),
                );
              }
            },
            child: Text(l10n.loginSendLink),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.isWorker) {
              context.go(AppRouter.workerDashboard);
            } else {
              context.go(AppRouter.home);
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthPasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.loginResetSent),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                // Logo + Language switcher
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Usta App',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    // ─── Language Switcher ───────────────────────────────
                    _LanguageSwitcher(),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  l10n.loginTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loginSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 36),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: l10n.authEmailLabel,
                        hint: l10n.authEmailHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.authEmailRequired;
                          }
                          if (!v.contains('@')) {
                            return l10n.authEmailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: l10n.authPasswordLabel,
                        hint: l10n.authPasswordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.authPasswordRequired;
                          }
                          if (v.length < 6) {
                            return l10n.authPasswordTooShort;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showForgotPasswordDialog(l10n),
                    child: Text(l10n.loginForgotPassword),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GradientButton(
                      onPressed: state is AuthLoading ? null : _login,
                      isLoading: state is AuthLoading,
                      label: l10n.authSignIn,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.loginNoAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRouter.register),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        l10n.loginRegister,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Language switcher button shown on Login screen
class _LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          tooltip: l10n.settingsLanguage,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 20),
              const SizedBox(width: 4),
              Text(
                state.locale.languageCode.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          onSelected: (code) {
            context.read<LocaleBloc>().add(LocaleChanged(Locale(code)));
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'kk',
              child: Row(
                children: [
                  if (state.locale.languageCode == 'kk')
                    const Icon(Icons.check, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(l10n.langKk),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'ru',
              child: Row(
                children: [
                  if (state.locale.languageCode == 'ru')
                    const Icon(Icons.check, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(l10n.langRu),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
