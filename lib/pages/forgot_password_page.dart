import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/main.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  late final TextEditingController _email;

  /// Initialize variabkes to store email
  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  /// Dispose of the email and password when page closes.
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GrinSync Password Reset'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: 'Email',
                  hintText: 'Enter the email associated with your account',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 218, 41, 28),
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    var auth = await passwordReset(_email.text);
                    // If string was returned, login failed.
                    if (auth.runtimeType == String) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Login Failed'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      'The email provided does not match any current GrinSync accounts.'),
                                  Text(
                                      'Please enter an email connected to a GrinSync account.'),
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
                    else if (auth.runtimeType == String) {
                      // Open the app home page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    }
                  },
                  child: const Text('Log in')),
            )
          ]),
        )));
  }
}
