// main.dart
import 'package:flutter/material.dart';
import 'package:my_first_app/signup.dart';

void main() => runApp(Authentication());

class Authentication extends StatelessWidget {
  final Color primaryBlue = const Color(0xFF235B9F); // Theme blue from image1

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: primaryBlue, secondary: Colors.blueAccent),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}


class LoginScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: emailCtrl, decoration: InputDecoration(hintText: "Email")),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {}, // TODO: Add logic
                child: Center(child: Text("Sign In")),
              ),
              const SizedBox(height: 24),
              Text("Or sign in with"),
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen())),
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [TextSpan(text: "Sign Up", style: TextStyle(color: Theme.of(context).primaryColor))],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
