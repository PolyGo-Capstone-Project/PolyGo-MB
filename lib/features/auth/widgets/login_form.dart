import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/responsive.dart'; // import responsive helper

class LoginForm extends StatefulWidget {
  final bool isTablet;
  final bool isDesktop;

  const LoginForm({super.key, this.isTablet = false, this.isDesktop = false});

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
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login successful!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;
    final loc = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // --- Max width container ---
    final containerWidth = screenWidth < 500
        ? screenWidth * 0.9
        : screenWidth < 800
        ? 450.0
        : 500.0;

    return Center(
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.all(sw(context, 24)),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(sw(context, 16)),
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
              // Logo
              Center(
                child: Container(
                  padding: EdgeInsets.all(sw(context, 12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(sw(context, 12)),
                  ),
                  child: Icon(Icons.layers_rounded,
                      size: sw(context, 36), color: const Color(0xFF2563EB)),
                ),
              ),
              SizedBox(height: sh(context, 20)),

              // Title
              Text(
                loc.translate("login_title"),
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: st(context, 24)),
              ),
              SizedBox(height: sh(context, 6)),
              Text(
                loc.translate("login_subtitle"),
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline, fontSize: st(context, 14)),
              ),
              SizedBox(height: sh(context, 32)),

              // Email
              Text(loc.translate("email"),
                  style: t.labelLarge?.copyWith(fontSize: st(context, 14))),
              SizedBox(height: sh(context, 8)),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "user@example.com",
                  prefixIcon: Icon(Icons.mail_outline, size: sw(context, 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) =>
                (v == null || !v.contains('@')) ? "Invalid email" : null,
              ),
              SizedBox(height: sh(context, 16)),

              // Password
              Text(loc.translate("password"),
                  style: t.labelLarge?.copyWith(fontSize: st(context, 14))),
              SizedBox(height: sh(context, 8)),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: Icon(Icons.lock_outline, size: sw(context, 20)),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) =>
                (v == null || v.length < 6) ? "Min 6 characters" : null,
              ),
              SizedBox(height: sh(context, 12)),

              // Remember me / Forgot password
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) => setState(() => _rememberMe = v!),
                        ),
                        Flexible(
                          child: Text(
                            loc.translate("remember_me"),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      loc.translate("forgot_password"),
                      style: TextStyle(
                          color: const Color(0xFF2563EB),
                          fontSize: st(context, 14)),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(height: sh(context, 20)),

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: EdgeInsets.symmetric(vertical: sh(context, 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sw(context, 10))),
                ),
                onPressed: _isLoading ? null : _onSubmit,
                child: Text(
                  _isLoading ? "Logging in..." : loc.translate("login_button"),
                  style: TextStyle(fontSize: st(context, 16), color: Colors.white),
                ),
              ),

              // Divider + Google + Register
              SizedBox(height: sh(context, 24)),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw(context, 12)),
                    child: Text(
                      loc.translate("or_continue_with"),
                      style: t.bodySmall
                          ?.copyWith(color: Colors.grey, fontSize: st(context, 12)),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              SizedBox(height: sh(context, 24)),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.g_mobiledata, size: sw(context, 28),
                ),
                label: Text(
                  loc.translate("login_google"),
                  style: TextStyle(fontSize: st(context, 16),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: sh(context, 14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              SizedBox(height: sh(context, 24)),
              Text.rich(
                TextSpan(
                  text: loc.translate("no_account") + ' ',
                  style: t.bodyMedium
                      ?.copyWith(color: Colors.grey, fontSize: st(context, 14)),
                  children: [
                    TextSpan(
                      text: loc.translate("signup_now"),
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                        fontSize: st(context, 14),
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
