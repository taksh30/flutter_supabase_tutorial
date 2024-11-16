import 'package:flutter/material.dart';
import 'package:supabase_tutorial/components/my_text_field.dart';
import 'package:supabase_tutorial/pages/register_page.dart';
import 'package:supabase_tutorial/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  final _authService = AuthService();

  void _login() async {
    final email = _emailCtr.text;
    final password = _passwordCtr.text;
    try {
      await _authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade400,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: _emailCtr,
              hintText: 'Email',
              obscureText: false,
            ),
            MyTextField(
              controller: _passwordCtr,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _login,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade400,
                ),
                child: Text('Sign In'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Don\'t have an account? Sign Up')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
