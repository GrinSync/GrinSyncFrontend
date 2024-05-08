import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/pages/connect_org_page.dart';
import 'package:flutter_test_app/models/org_models.dart';

class MyOrgsPage extends StatefulWidget {
  MyOrgsPage({Key? key}) : super(key: key);

  @override
  State<MyOrgsPage> createState() => _MyOrgsPageState();
}

class _MyOrgsPageState extends State<MyOrgsPage> {
  late List<Org> orgs = [];
  late Future _loadOrgsFuture;

  @override
  initState() {
    super.initState();
    _loadOrgsFuture = loadOrgs();
  }

  Future<void> loadOrgs() async {
    orgs = await getUserOrgs(); // function in get_orgs.dart
    await setStudentOrgs();
  }

  refresh() {
    setState(() {
      _loadOrgsFuture = loadOrgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Organizations',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Connect to a new student organization',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectOrgPage()));
              }),
        ],
      ),
      body: FutureBuilder(
        future: _loadOrgsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Loading organizations...'),
                ],
              ),
            );
          } else if (orgs.isEmpty) {
            return Center(
              child: Text('You are not a member of any organizations.'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey, height: 0),
            itemCount: orgs.length,
            itemBuilder: (context, index) {
              return OrgCard(
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
