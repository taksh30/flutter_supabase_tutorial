import 'package:flutter/material.dart';
import 'package:supabase_tutorial/components/my_text_field.dart';
import 'package:supabase_tutorial/models/users_model.dart';
import 'package:supabase_tutorial/services/auth_service.dart';
import 'package:supabase_tutorial/services/user_database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmPasswordCtr = TextEditingController();

  final _authService = AuthService();
  final _userDB = UserDatabase();

  void signUp() async {
    final email = _emailCtr.text;
    final password = _passwordCtr.text;
    final confirmPassword = _confirmPasswordCtr.text;

    if (confirmPassword != password) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords don\'t match')));
      return;
    }
    try {
      await _authService.signUpWithEmailPassword(email, password);

      final user = UsersModel(email: email);

      await _userDB.addUserEmail(user);

      Navigator.pop(context);
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
        title: Text('Sign Up'),
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
            MyTextField(
              controller: _confirmPasswordCtr,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: signUp,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade400,
                ),
                child: Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
