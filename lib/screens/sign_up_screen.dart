import 'package:finlearn/screens/main_screen.dart';
import 'package:finlearn/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:finlearn/l10n/app_localizations.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        print('SignUpScreen: Starting sign up process');
        final result = await _authService.signUpWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        print('SignUpScreen: Sign up completed, user: ${result?.user?.email}');

        if (mounted && result?.user != null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.translate('account_created'),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              duration: const Duration(milliseconds: 1500),
            ),
          );

          // Give a moment for the snackbar, then navigate
          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            print('SignUpScreen: Navigating to MainScreen');
            // Use pushReplacementNamed to replace the current route
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          }
        }
      } catch (e) {
        print('SignUpScreen: Error - $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo with gradient background
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 60,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Welcome text
                  Text(
                    AppLocalizations.of(context)!.translate('create_account'),
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.translate('sign_up_subtitle'),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('full_name'),
                      hintText: AppLocalizations.of(
                        context,
                      )!.translate('enter_full_name'),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('enter_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('email_address'),
                      hintText: AppLocalizations.of(
                        context,
                      )!.translate('enter_email'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('enter_your_email_required');
                      }
                      if (!value.contains('@')) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('enter_valid_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('password'),
                      hintText: AppLocalizations.of(
                        context,
                      )!.translate('create_password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('enter_password');
                      }
                      if (value.length < 6) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('enter_password_chars');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('confirm_password'),
                      hintText: AppLocalizations.of(
                        context,
                      )!.translate('re_enter_password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('confirm_password_required');
                      }
                      if (value != _passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.translate('passwords_no_match');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  SizedBox(
                    height: 56.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(
                                context,
                              )!.translate('sign_up'),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: textTheme.bodySmall),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.translate('already_have_account'),
                        style: textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('sign_in'),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
