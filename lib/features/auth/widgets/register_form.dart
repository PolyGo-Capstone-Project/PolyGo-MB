import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../core/api/api_client.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/auth/register_request.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_service.dart';
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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _otpController = TextEditingController();
  bool _isSendingOtp = false;

  final apiClient = ApiClient();
  late final AuthRepository authRepository;

  bool _showOtpField = false;

  Future<void> _sendOtp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate("invalid_email"))),
      );
      return;
    }

    setState(() => _isSendingOtp = true);

    try {
      // Gọi API gửi OTP thật
      await authRepository.sendOtp(
        mail: _emailController.text.trim(),
        verificationType: 0, // 0 là dành cho register
      );

      setState(() {
        _showOtpField = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate("otp_sent_success")),
        ),
      );
    } catch (e) {
      print("Send OTP error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate("otp_sent_failed")),
        ),
      );
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate("agree_terms_error"))),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final req = RegisterRequest(
        name: _nameController.text.trim(),
        mail: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        otp: _otpController.text.trim(),
      );

      await authRepository.register(req);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate("register_success"))),
      );

      Navigator.pushNamed(context, AppRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate("register_failed"))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final authService = AuthService(apiClient);
    authRepository = AuthRepository(authService);
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
              // Logo
              Center(
                child: Container(
                  padding: EdgeInsets.all(sw(context, 12)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(sw(context, 12)),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    size: sw(context, 36),
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              SizedBox(height: sh(context, 20)),

              // Title
              Text(
                loc.translate("signup_title"),
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, fontSize: st(context, 24)),
              ),
              SizedBox(height: sh(context, 6)),
              Text(
                loc.translate("signup_subtitle"),
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                    fontSize: st(context, 14)),
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
                validator: (v) =>
                (v == null || v.isEmpty) ? loc.translate("null") : null,
              ),
              SizedBox(height: sh(context, 16)),

              // Email + Gửi OTP trong cùng hàng
              Text(
                loc.translate("email"),
                style: t.labelLarge?.copyWith(fontSize: st(context, 14)),
              ),
              SizedBox(height: sh(context, 8)),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ô nhập Email
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "user@example.com",
                            prefixIcon: Icon(Icons.mail_outline, size: sw(context, 20)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(sw(context, 10)),
                            ),
                            errorStyle: const TextStyle(height: 0), // ẩn chỗ trống lỗi
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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

                        // Hiển thị lỗi riêng (ngoài Row, không đẩy layout)
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, value, _) {
                            final text = value.text.trim();
                            if (text.isEmpty) return const SizedBox.shrink(); // không hiển thị khi chưa nhập
                            if (!text.contains('@')) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  loc.translate("invalid_email"),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: st(context, 12),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: sw(context, 8)),

                  // Nút Gửi OTP
                  SizedBox(
                    height: 56, // cố định chiều cao để không bị lệch
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(sw(context, 10)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: sw(context, 16)),
                        minimumSize: Size(0, 56),
                      ),
                      onPressed: _isLoading ? null : _sendOtp,
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

              // Ô nhập OTP (hiện ra sau khi gửi)
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
                validator: (v) => (v == null || v.length < 6)
                    ? loc.translate("min_6_char")
                    : null,
              ),
              SizedBox(height: sh(context, 16)),

              // Confirm password
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
                      style:
                      t.bodyMedium?.copyWith(fontSize: st(context, 14)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sh(context, 20)),

              // Register Button (AppButton)
              AppButton(
                text: _isLoading
                    ? loc.translate("signing_up")
                    : loc.translate("signup_button"),
                onPressed: _isLoading ? null : _onSubmit,
                size: ButtonSize.lg,
                variant: ButtonVariant.primary,
                disabled: _isLoading,
              ),

              // Divider
              SizedBox(height: sh(context, 24)),
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw(context, 12)),
                    child: Text(
                      loc.translate("or_continue_with"),
                      style: t.bodySmall?.copyWith(
                          color: Colors.grey, fontSize: st(context, 12)),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),

              // Google signup
              SizedBox(height: sh(context, 24)),
              AppButton(
                text: loc.translate("signup_google"),
                icon: const Icon(Icons.g_mobiledata, size: 28),
                variant: ButtonVariant.outline,
                size: ButtonSize.lg,
                onPressed: () {},
              ),

              // Login link
              SizedBox(height: sh(context, 24)),
              Text.rich(
                TextSpan(
                  text: loc.translate("have_account") + ' ',
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
