import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/launch_url.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          //padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(60, 60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Sign in to continue.",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 50,
                    ),

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
                  ]),
            ),
            // Create Forgot Password Button
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      // Send to forgot password page when pressed
                      final Uri url =
                          Uri.parse('https://grinsync.com/auth/password_reset');
                      urlLauncher(url);
                    },
                    child: const Text('Forgot Password?'))),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  // Create Login Button
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 218, 41, 28),
                          foregroundColor: Colors.black),
                      onPressed: () async {
                        // Authorize user with provided credentials
                        var auth = await userAuthentication(
                            _email.text, _password.text);
                        // If string was returned, login failed.
                        if (auth.runtimeType == String) {
                          showDialog(
                            // Show error message that credentials provided were incorrect
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
                          // Set login status to logged in
                          await setLoginStatus();
                          // Open the app home page
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const MyApp()),
                          // );
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: "Login Successful",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,);
                        }
                      },
                      child: const Text('Log in')),
                ))
          ]),
        ));
  }
}
