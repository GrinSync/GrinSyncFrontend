import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/org.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:flutter_test_app/pages/user_profile_page.dart';

class CreateOrgPage extends StatefulWidget {
  const CreateOrgPage({super.key});
  @override
  State<CreateOrgPage> createState() => _CreateOrgPage();
}

class _CreateOrgPage extends State<CreateOrgPage> {
  /// Variables to store email
  late final TextEditingController _email;
  late final TextEditingController _orgName;
  late final TextEditingController _orgCode;

  /// Initialize variables to store email and password for the login page
  @override
  void initState() {
    _email = TextEditingController();
    _orgCode = TextEditingController();
    _orgName = TextEditingController();
    super.initState();
  }

  /// Dispose of the email and password when page closes.
  @override
  void dispose() {
    _email.dispose();
    _orgCode.dispose();
    _orgName.dispose();
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
                    Icons.people,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create a Student Org",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Please enter the organization's name and email",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    // Create a TextField for the user to enter the org email
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
                    TextField(
                      controller: _orgName,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.border_color),
                          labelText: 'Organization Full Name',
                          hintText: 'Enter your organization name',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _orgCode,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.border_color),
                          labelText: 'Organization Acronym/Preferred Name',
                          hintText: 'Enter your organization\'s preferred name',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                  ]),
            ),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  // Create Org Creation Button
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 218, 41, 28),
                          foregroundColor: Colors.black),
                      onPressed: () async {
                        // Authorize user with provided credentials
                        var auth = await createOrg(
                            _email.text, _orgName.text, _orgCode.text);
                        if (auth == 'Success'){
                            Navigator.of(context).pop();
                        }
                        else{
                        }
                      },
                      child: const Text('Create Org')),
                ))
          ]),
        ));
  }
}
