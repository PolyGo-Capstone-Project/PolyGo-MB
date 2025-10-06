import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../routes/app_routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // mock login
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login successful!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;
    final loc = AppLocalizations.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Logo ---
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.layers_rounded,
                      size: 36, color: Color(0xFF2563EB)),
                ),
              ),
              const SizedBox(height: 20),

              // --- Title ---
              Text(
                loc.translate("login_title"),
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                loc.translate("login_subtitle"),
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 32),

              // --- Email ---
              Text(loc.translate("email"), style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "user@example.com",
                  prefixIcon: const Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v == null || !v.contains('@')) ? "Invalid email" : null,
              ),
              const SizedBox(height: 16),

              // --- Password ---
              Text(loc.translate("password"), style: t.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) =>
                (v == null || v.length < 6) ? "Min 6 characters" : null,
              ),
              const SizedBox(height: 12),

              // --- Remember me / Forgot password ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v!),
                      ),
                      Text(loc.translate("remember_me")),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      loc.translate("forgot_password"),
                      style: const TextStyle(color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Login Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _onSubmit,
                child: Text(
                  _isLoading
                      ? "Logging in..."
                      : loc.translate("login_button"),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // --- Divider ---
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      loc.translate("or_continue_with"),
                      style: t.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),

              // --- Google Button ---
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata,
                    size: 28, color: Colors.black),
                label: Text(
                  loc.translate("login_google"),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // --- Register link ---
              Text.rich(
                TextSpan(
                  text: loc.translate("no_account") + ' ',
                  style: t.bodyMedium?.copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: loc.translate("signup_now"),
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
