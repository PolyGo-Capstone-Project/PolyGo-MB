import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/utils/responsive.dart';

class ForgetPasswordForm extends StatefulWidget {
  final bool isTablet;
  final bool isDesktop;

  const ForgetPasswordForm({super.key, this.isTablet = false, this.isDesktop = false});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSendingOtp = false;
  bool _isLoading = false;
  bool _showOtpField = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _sendOtp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate("invalid_email"))),
      );
      return;
    }

    setState(() => _isSendingOtp = true);
    await Future.delayed(const Duration(seconds: 2)); // Giả lập gửi OTP
    setState(() {
      _showOtpField = true;
      _isSendingOtp = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).translate("otp_sent_success"))),
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // giả lập xử lý

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).translate("reset_success"))),
    );

    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.login);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;
    final loc = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

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
              // Icon
              Center(
                child: Container(
                  padding: EdgeInsets.all(sw(context, 12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(sw(context, 12)),
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: sw(context, 36),
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              SizedBox(height: sh(context, 20)),

              // Title
              Text(
                loc.translate("forget_password_title"),
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: st(context, 24),
                ),
              ),
              SizedBox(height: sh(context, 6)),
              Text(
                loc.translate("forget_password_subtitle"),
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                  fontSize: st(context, 14),
                ),
              ),
              SizedBox(height: sh(context, 32)),

              // Email + Gửi OTP
              Text(
                loc.translate("email"),
                style: t.labelLarge?.copyWith(fontSize: st(context, 14)),
              ),
              SizedBox(height: sh(context, 8)),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "user@example.com",
                        prefixIcon: Icon(Icons.mail_outline, size: sw(context, 20)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(sw(context, 10)),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return loc.translate("null");
                        }
                        if (!v.contains('@')) {
                          return loc.translate("invalid_email");
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: sw(context, 8)),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(context, 10)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: sw(context, 16)),
                      ),
                      onPressed: _isSendingOtp ? null : _sendOtp,
                      child: _isSendingOtp
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        loc.translate("send_otp"),
                        style: TextStyle(
                          fontSize: st(context, 14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: sh(context, 16)),

              // OTP field
              if (_showOtpField) ...[
                Text(loc.translate("enter_otp"),
                    style: t.labelLarge?.copyWith(fontSize: st(context, 14))),
                SizedBox(height: sh(context, 8)),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "123456",
                    prefixIcon: Icon(Icons.numbers_outlined, size: sw(context, 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(sw(context, 10)),
                    ),
                  ),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? loc.translate("null") : null,
                ),
                SizedBox(height: sh(context, 16)),
              ],

              // New password
              Text(loc.translate("new_password"),
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
                validator: (v) => (v == null || v.length < 6)
                    ? loc.translate("min_6_char")
                    : null,
              ),
              SizedBox(height: sh(context, 16)),

              // Confirm password
              Text(loc.translate("confirm_new_password"),
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
                    onPressed: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sw(context, 10)),
                  ),
                ),
                validator: (v) =>
                (v != _passwordController.text) ? loc.translate("not_match") : null,
              ),

              SizedBox(height: sh(context, 24)),

              // Reset button
              AppButton(
                text: _isLoading
                    ? loc.translate("resetting_password")
                    : loc.translate("reset_password_button"),
                onPressed: _isLoading ? null : _onSubmit,
                size: ButtonSize.lg,
                variant: ButtonVariant.primary,
                disabled: _isLoading,
              ),

              // Back to login link
              SizedBox(height: sh(context, 24)),
              Text.rich(
                TextSpan(
                  text: loc.translate("remember_password") + ' ',
                  style: t.bodyMedium?.copyWith(
                      color: Colors.grey, fontSize: st(context, 14)),
                  children: [
                    TextSpan(
                      text: loc.translate("login_now"),
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                        fontSize: st(context, 14),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
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
