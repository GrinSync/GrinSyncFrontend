import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
          return ListView.separated(
              separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 0),
              itemCount: orgs.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(orgs[index].id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        unfollowOrg(orgs[index].id);
                        setState(() {
                          orgs.removeAt(index);
                        });
                        //refresh();
                      },
                    ),
                    children: [
                      SlidableAction(
                                onPressed: (context) {
                                  // Remove the event from the user's liked events
                                  unfollowOrg(orgs[index].id);
                                  orgs.removeAt(index);
                                  refresh();
                                },
                                label: 'Unsave',
                                backgroundColor: Colors.red,
                              ),
                    ],
                  ),
                  child: OrgCard(
                    org: orgs[index],
                    refreshParent: refresh,
                  ),
                );
              },
          );
        },
        ),
    );
  }
}