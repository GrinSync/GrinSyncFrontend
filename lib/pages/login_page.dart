import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/constants.dart';
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_outline_outlined),
            labelText: 'Email',
            hintText: 'Enter your email',
            border: OutlineInputBorder()
            ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _password,
          autocorrect: false,
          obscureText: true,
          enableSuggestions: false,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.fingerprint),
            labelText: 'Password',
            hintText: 'Enter your password',
            border: OutlineInputBorder(),
            // suffixIcon: IconButton(
            //   onPressed: null,
            //   icon: Icon(Icons.remove_red_eye_sharp)
            // )
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){},
            child: const Text('Forgot Password?')
          )
        ),
        Align(
          alignment: Alignment.center,
        child: ElevatedButton(
            onPressed: () async {
              var auth = await userAuthentication(_email.text, _password.text);
              if (auth.runtimeType == String){
                print("These Login credentials are invalid");
              }
              else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
          );
              }
            },
            child: const Text('Log in')),
        )
      ]),
      )
      )
    );
  }
}
