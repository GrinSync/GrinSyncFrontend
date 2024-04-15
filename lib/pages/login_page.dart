import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/main.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  /// Variables to store email and password
  late final TextEditingController _email;
  late final TextEditingController _password;

  /// Initialize variables to store email and password for the login page
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  /// Dispose of the email and password when page closes.
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Build the Login Page interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('GrinSync Login'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Create a TextField for the user to enter their username
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    // Create a TextField for the user to enter their password
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Create Forgot Password Button
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () { // Send to forgot password page when pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordPage()),
                              );
                            },
                            child: const Text('Forgot Password?'))),
                    SizedBox(
                      width: double.infinity,
                      // Create Login Button
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 143, 28),
                              foregroundColor: Colors.black),
                          onPressed: () async { // Authorize user with provided credentials
                            var auth = await userAuthentication(
                                _email.text, _password.text);
                            // If string was returned, login failed.
                            if (auth.runtimeType == String) {
                              showDialog( // Show error message that credentials provided were incorrect
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Login Failed'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'The Login credentials provided do not match a user.'),
                                          Text(
                                              'Please re-enter your credentials and try again.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Okay'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } 
                            // If user was returned, login succeeded!
                            else if (auth.runtimeType == User) {
                              // Open the app home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                              );
                            }
                          },
                          child: const Text('Log in')),
                    )
                  ]),
            )));
  }
}
