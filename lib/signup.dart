// screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:my_first_app/authentication.dart';

class SignUpScreen extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(hintText: "Name")),
              const SizedBox(height: 16),
              TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(hintText: "Email")),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (v) {}),
                  Text.rich(
                    TextSpan(
                      text: "Agree with ",
                      children: [
                        TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor))
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Authentication()));
                },
                child: Center(child: Text("Sign Up")),
              ),
              const SizedBox(height: 24),
              Text("Or sign up with"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple, size: 32),
                  const SizedBox(width: 24),
                  Icon(Icons.g_mobiledata, size: 32),
                  const SizedBox(width: 24),
                  Icon(Icons.facebook, size: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
