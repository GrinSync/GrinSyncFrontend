import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/models/org_models.dart';
import 'package:flutter_test_app/pages/org_details_page.dart';

class OrgsIFollowPage extends StatefulWidget {
  @override
  _OrgsIFollowPageState createState() => _OrgsIFollowPageState();
}

class _OrgsIFollowPageState extends State<OrgsIFollowPage> {
  List<Org> orgs = [];
  late Future _loadOrgsFuture;

  @override 
  initState() {
    super.initState();
    _loadOrgsFuture = loadOrgs();
  }

  Future<void> loadOrgs() async {
    orgs = await getFollowedOrgs(); // function in get_orgs.dart
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
        title: Text('Organizations I Follow', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
              child: 
                  Text('You are not following any organizations.'),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Organizations I Follow', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            body: ListView.separated(
              separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 0),
              itemCount: orgs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orgs[index].name, style: TextStyle(fontSize: 20, fontFamily: 'Helvetica', fontWeight: FontWeight.bold)),
                  subtitle: Text(orgs[index].email, style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrgDetailsPage(org: orgs[index], refreshParent: refresh,)));
                  },
                );
              },
            ),
          );
        },
        ),
    );
  }
}