import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini_ai/core/custom/custom_button.dart';
import 'package:flutter_gemini_ai/core/custom/custom_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Enter your credentials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextFormField(
              controller: _emailController,
              hintText: 'Enter your email',
              obscure: false,
              maxLines: 1,
              // minLines: 1,
              validator: (p0) {
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              controller: _passwordController,
              hintText: 'Enter your password',
              obscure: true,
              maxLines: 1,
              validator: (p0) {
                return null;
              },
              // focusNode: ,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              title: 'Login',
              onPressed: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              title: 'SignIn with google',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
