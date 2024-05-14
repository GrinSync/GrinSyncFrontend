import 'package:flutter/material.dart';
import 'package:grinsync/api/get_student_orgs.dart';
import 'package:grinsync/pages/connect_org_page.dart';
import 'package:grinsync/models/org_models.dart';

class MyOrgsPage extends StatefulWidget {
  const MyOrgsPage({super.key});

  @override
  State<MyOrgsPage> createState() => _MyOrgsPageState();
}

class _MyOrgsPageState extends State<MyOrgsPage> {
  late List<Org> orgs = []; // Initialize list to store organizations
  late Future _loadOrgsFuture;

  // On page inititalization, set the LoadOrgs function to be ran
  // by the Future builder when the widget is created
  @override
  initState() {
    super.initState();
    _loadOrgsFuture = loadOrgs();
  }

  /// Get user orgs
  Future<void> loadOrgs() async {
    orgs = await getUserOrgs();
    await setStudentOrgs();
  }

  /// When page is refreshed, refresh the orgs
  refresh() {
    setState(() {
      _loadOrgsFuture = loadOrgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Organizations',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Connect to a new student organization',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectOrgPage()));
              }),
        ],
      ),
      body: FutureBuilder(
        future: _loadOrgsFuture, // Get Orgs
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Loading organizations...'),
                ],
              ),
            );
          } else if (orgs.isEmpty) {
            // If there are no orgs, return message telling user
            return const Center(
              child: Text('You are not a member of any organizations.'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, height: 0),
            itemCount: orgs.length,
            itemBuilder: (context, index) {
              return OrgCard(
                // Return card for each org
                org: orgs[index],
                refreshParent: refresh,
              );
            },
          );
        },
      ),
    );
  }
}
