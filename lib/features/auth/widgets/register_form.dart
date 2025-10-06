import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/responsive.dart';

class RegisterForm extends StatefulWidget {
  final bool isTablet;
  final bool isDesktop;

  const RegisterForm({super.key, this.isTablet = false, this.isDesktop = false});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreeTerms = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate("agree_terms_error")),
      ));
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)
          .translate("register_success")),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;
    final loc = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // --- Max width container đồng bộ với LoginForm ---
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
                  child: Icon(Icons.person_add_alt_1_rounded,
                      size: sw(context, 36), color: const Color(0xFF2563EB)),
                ),
              ),
              SizedBox(height: sh(context, 20)),

              // Title
              Text(
                loc.translate("signup_title"),
                textAlign: TextAlign.center,
                style: t.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: st(context, 24)),
              ),
              SizedBox(height: sh(context, 6)),
              Text(
                loc.translate("signup_subtitle"),
                textAlign: TextAlign.center,
                style: t.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline, fontSize: st(context, 14)),
              ),
              SizedBox(height: sh(context, 32)),

              // Name
              Text(loc.translate("full_name"),
                  style: t.labelLarge?.copyWith(fontSize: st(context, 14))),
              SizedBox(height: sh(context, 8)),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nguyễn Văn A",
                  prefixIcon: Icon(Icons.person_outline, size: sw(context, 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? "Vui lòng nhập họ tên" : null,
              ),
              SizedBox(height: sh(context, 16)),

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
                validator: (v) => (v == null || !v.contains('@')) ? "Email không hợp lệ" : null,
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
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? "Mật khẩu tối thiểu 6 ký tự" : null,
              ),
              SizedBox(height: sh(context, 16)),

              // Confirm Password
              Text(loc.translate("confirm_password"),
                  style: t.labelLarge?.copyWith(fontSize: st(context, 14))),
              SizedBox(height: sh(context, 8)),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: Icon(Icons.lock_outline, size: sw(context, 20)),
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) => (v != _passwordController.text) ? "Mật khẩu không khớp" : null,
              ),
              SizedBox(height: sh(context, 12)),

              // Agree terms
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    onChanged: (v) => setState(() => _agreeTerms = v!),
                  ),
                  Expanded(
                    child: Text(
                      loc.translate("agree_terms"),
                      style: t.bodyMedium?.copyWith(fontSize: st(context, 14)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sh(context, 20)),

              // Register Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: EdgeInsets.symmetric(vertical: sh(context, 16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                onPressed: _isLoading ? null : _onSubmit,
                child: Text(
                  _isLoading ? (loc.translate("signing_up")) : (loc.translate("signup_button")),
                  style: TextStyle(fontSize: st(context, 16), color: Colors.white),
                ),
              ),
              SizedBox(height: sh(context, 24)),

              // Navigate to Login
              Text.rich(
                TextSpan(
                  text: (loc.translate("have_account")) + ' ',
                  style: t.bodyMedium?.copyWith(color: Colors.grey, fontSize: st(context, 14)),
                  children: [
                    TextSpan(
                      text: loc.translate("login_now"),
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                        fontSize: st(context, 14),
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.pushNamed(context, AppRoutes.login);
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
