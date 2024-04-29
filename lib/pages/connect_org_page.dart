import 'package:flutter/material.dart';

class ConnectOrgPage extends StatefulWidget {
  const ConnectOrgPage({super.key});
  @override
  State<ConnectOrgPage> createState() => _ConnectOrgPage();
}

class _ConnectOrgPage extends State<ConnectOrgPage> {

  /// Initialize variables to store email and password for the login page
  @override
  void initState() {
    super.initState();
  }

  /// Dispose of the email and password when page closes.
  @override
  void dispose() {
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
        body: const SingleChildScrollView(

        ));
  }
}
