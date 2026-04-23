import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackers/Login&Signup/sign_up.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';
import 'package:trackers/services/local_data_service.dart';
import 'package:trackers/utils/responsive.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/trainBackgrong/05.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: r.isPhone ? 20 : r.isTablet ? 80 : 0,
                  vertical: r.sp24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(r.sp24),
                    child: const _LoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(Icons.train, size: r.sp40, color: const Color(0xFF1A3A6B)),
          SizedBox(height: r.sp8),
          Text(
            'Welcome Back',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.fs24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A6B),
            ),
          ),
          Text(
            'Sign in to continue',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.fs13, color: Colors.grey),
          ),
          SizedBox(height: r.sp24),

          // Email
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: r.fs14),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: r.fs13),
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: r.sp16, vertical: r.sp14),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter your email' : null,
          ),
          SizedBox(height: r.sp14),

          // Password
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            style: TextStyle(fontSize: r.fs14),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: r.fs13),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: r.sp16, vertical: r.sp14),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Please enter your password' : null,
          ),
          SizedBox(height: r.sp24),

          // Login button
          SizedBox(
            height: r.btnH,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Login',
                      style: TextStyle(
                          fontSize: r.fs16, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: r.sp12),

          // Register link
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUp()),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: r.fs13, color: Colors.grey[700]),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: const Color(0xFF1A3A6B),
                      fontWeight: FontWeight.bold,
                      fontSize: r.fs14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await loginUser(_emailCtrl.text, _passCtrl.text);
    setState(() => _loading = false);
    if (result['success'] == true) {
      Fluttertoast.showToast(msg: 'Login successful');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainHomeScreen()),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: result['message'] ?? 'Failed to login',
          backgroundColor: Colors.red);
    }
  }
}

// Keep old class name for backward compat
class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});
  @override
  Widget build(BuildContext context) => const _LoginForm();
}

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  return await LocalDataService().login(email, password);
}
