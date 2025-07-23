import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/services/auth_service.dart';
import 'package:flutter_task/utils/exception_handler.dart';
import 'package:flutter_task/utils/helper.dart';
import 'package:flutter_task/utils/validator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final auth = AuthService();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (_isLogin) {
        await auth.signIn(email: email, password: password);
        Helper.showSnackBar(context, 'Login successful!', Colors.green);
      } else {
        await auth.signUp(email: email, password: password);
        Helper.showSnackBar(context, 'Registration successful!', Colors.green);
      }

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      final message =
          FirebaseExceptionHandler().friendlyFirebaseMessage(e.code);
      Helper.showSnackBar(context, message, Colors.grey);
    } catch (e) {
      Helper.showSnackBar(
          context, 'Something went wrong. Please try again.', Colors.grey);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: devWidth * 0.08),
          child: Column(
            children: [
              Image.asset(
                  _isLogin ? 'images/sign-in.png' : 'images/sign-up.png',
                  height: devHeight * 0.2),
              SizedBox(height: devHeight * 0.03),
              ToggleButtons(
                isSelected: [_isLogin, !_isLogin],
                onPressed: (index) => _toggleMode(),
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: Theme.of(context).primaryColor,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Login'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: Validator.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
