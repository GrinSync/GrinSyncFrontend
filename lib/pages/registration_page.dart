import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SingingCharacter { student, faculty, community } // Different account types

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  /// Variables to store registartion fields
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  SingingCharacter? _character = SingingCharacter.student;

  /// Initialize variables to store values from the registration page
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  /// Dispose of variables once the registration page closes
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create an Account'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // First Name Field
            TextField(
              controller: _firstName,
              autocorrect: false,
              enableSuggestions: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: 'First Name',
                hintText: 'Enter your first name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Last Name Field
            TextField(
              controller: _lastName,
              autocorrect: false,
              enableSuggestions: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Email Field
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            // Password Field
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
            // Confirm Password Field
            TextField(
              controller: _confirmPassword,
              autocorrect: false,
              obscureText: true,
              enableSuggestions: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: 'Confirm Password',
                hintText: 'Confirm your password from above',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Tiles to select account type
            ListTile(
              title: const Text('Student'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.student,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Faculty Member'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.faculty,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Community Member'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.community,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              // Submit Button to create account
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 143, 28),
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    var auth = await registerUser(
                        _firstName.text,
                        _lastName.text,
                        _email.text,
                        _password.text,
                        _confirmPassword.text,
                        _character);
                    // If null was returned, account creation failed.
                    if (auth == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Registration Failed'),
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
                      // If string was returned, registration succeeded!
                    } else if (auth.runtimeType == String) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        // show toast message that the verification email has been sent
                        msg:
                            "A verification email has been sent to your email address. Please verify your email address to login.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  },
                  child: const Text('Register')),
            )
          ]),
        )));
  }
}
