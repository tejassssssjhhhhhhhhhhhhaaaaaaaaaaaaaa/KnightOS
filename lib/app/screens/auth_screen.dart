import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/repositories/authentication_repository.dart';
import '../../core/router/app_routes.dart';
import '../../features/onboarding/data/onboarding_storage.dart';
import '../widgets/knight_page_scaffold.dart';

enum _AuthFlow { signIn, register, forgotEmail, forgotSuccess }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _authRepository = AuthenticationRepository();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _successMessage;
  _AuthFlow _flow = _AuthFlow.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final displayName = _nameController.text.trim();

    setState(() {
      _loading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      if (_flow == _AuthFlow.register) {
        await _authRepository.signUp(email: email, password: password, displayName: displayName);
        if (!mounted) return;
        setState(() {
          _flow = _AuthFlow.signIn;
          _successMessage = 'Your account has been created successfully. Please sign in to continue.';
          _passwordController.clear();
        });
        return;
      }

      if (_flow == _AuthFlow.forgotEmail) {
        await _authRepository.resetPassword(email);
        if (!mounted) return;
        setState(() {
          _flow = _AuthFlow.forgotSuccess;
          _successMessage = 'Password reset instructions were sent to $email.';
        });
        return;
      }

      final session = await _authRepository.signIn(email: email, password: password);
      if (!mounted) return;
      final onboardingStorage = OnboardingStorage();
      final profile = await onboardingStorage.loadProfile();
      final onboardingComplete = profile != null && profile.completedSteps.isNotEmpty;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome back, ${session.displayName}')),
      );
      context.go(onboardingComplete ? AppRoutes.dashboard : AppRoutes.onboarding);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _friendlyMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyMessage(Object error) {
    if (error is ArgumentError) {
      return error.message.toString();
    }
    return 'We could not complete that request. Please try again in a moment.';
  }

  void _switchToRegister() {
    setState(() {
      _flow = _AuthFlow.register;
      _error = null;
      _successMessage = null;
    });
  }

  void _switchToForgotPassword() {
    setState(() {
      _flow = _AuthFlow.forgotEmail;
      _error = null;
      _successMessage = null;
    });
  }

  void _returnToLogin() {
    setState(() {
      _flow = _AuthFlow.signIn;
      _error = null;
      _successMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRegistration = _flow == _AuthFlow.register;
    final isForgotPassword = _flow == _AuthFlow.forgotEmail;
    final isForgotSuccess = _flow == _AuthFlow.forgotSuccess;

    return KnightPageScaffold(
      title: _flow == _AuthFlow.register ? 'Create Account' : 'Log in to KnightOS',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isForgotSuccess
                  ? 'Reset complete'
                  : isForgotPassword
                      ? 'Reset your password'
                      : isRegistration
                          ? 'Create your KnightOS account'
                          : 'Log in to KnightOS',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              isForgotSuccess
                  ? 'We have prepared the next step for you. Please return to login to continue.'
                  : isForgotPassword
                      ? 'Enter your email address and we will validate your account.'
                      : isRegistration
                          ? 'Create your account, then sign in from the next screen.'
                          : 'Use your email and password to access your dashboard.',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            if (isRegistration)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Display name'),
              )
            else if (isForgotPassword || isForgotSuccess)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              )
            else
              const SizedBox.shrink(),
            if (!isForgotSuccess && !isRegistration && !isForgotPassword)
              Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
            if (isRegistration)
              Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _successMessage!,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ),
            if (isForgotSuccess)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _returnToLogin,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Return to Login'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(isForgotPassword ? Icons.lock_reset_rounded : Icons.lock_open_rounded),
                  label: Text(
                    isForgotPassword ? 'Reset Password' : isRegistration ? 'Create Account' : 'Sign In',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (!isForgotSuccess)
                  TextButton(
                    onPressed: _loading ? null : () {
                      if (_flow == _AuthFlow.register) {
                        _returnToLogin();
                      } else {
                        _switchToRegister();
                      }
                    },
                    child: Text(isRegistration ? 'Sign In' : 'Create Account'),
                  ),
                if (!isForgotSuccess && _flow != _AuthFlow.forgotEmail)
                  TextButton(onPressed: _loading ? null : _switchToForgotPassword, child: const Text('Forgot Password')),
                if (_flow == _AuthFlow.forgotEmail || _flow == _AuthFlow.forgotSuccess)
                  TextButton(onPressed: _loading ? null : _returnToLogin, child: const Text('Return to Login')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
