import 'package:flutter/material.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/pages/connect_org_page.dart';
import 'package:flutter_test_app/pages/org_details_page.dart';
import 'package:flutter_test_app/models/org_models.dart';

class MyOrgsPage extends StatelessWidget {
  final List<Org> studentOrgs = List<Org>.from(STUDENTORGS);

  // constructor
  MyOrgsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Organizations', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Connect to a new student organization',
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectOrgPage()));
            }),
        ],
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(color: Colors.grey, height:0),
          itemCount: studentOrgs.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(studentOrgs[index].name ?? 'Null Org Name', style: TextStyle(fontSize: 20, fontFamily: 'Helvetica', fontWeight: FontWeight.bold)),
                subtitle: Text(studentOrgs[index].email ?? 'Null Org Email', style: TextStyle(fontSize: 15)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrgDetailsPage()));
                },
            );
          },
        ),
    );
  }
}