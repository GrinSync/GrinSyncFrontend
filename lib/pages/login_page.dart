import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrinSync Login'),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        TextField(
          controller: _password,
          autocorrect: false,
          obscureText: true,
          enableSuggestions: false,
          decoration: const InputDecoration(hintText: 'Enter your password'),
        ),
        TextButton(
            onPressed: () async {
              await userAuthentication(_email.text, _password.text);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
          );
            },
            child: const Text('Register')),
      ]),
    );
  }
}
