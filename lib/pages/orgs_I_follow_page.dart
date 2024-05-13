import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';
import 'package:flutter_test_app/models/org_models.dart';

class OrgsIFollowPage extends StatefulWidget {
  const OrgsIFollowPage({super.key});

  @override
  _OrgsIFollowPageState createState() => _OrgsIFollowPageState();
}

class _OrgsIFollowPageState extends State<OrgsIFollowPage> {
  /// List of student organizations the current user follows
  List<Org> orgs = [];

  late Future _loadOrgsFuture;

  // On page initialization, load the list of student organizations the current user follows
  @override
  initState() {
    super.initState();
    _loadOrgsFuture = loadOrgs();
  }

  Future<void> loadOrgs() async {
    orgs = await getFollowedOrgs();
  }

  /// Reloads the list of student organizations as the user refreshes the page
  refresh() {
    setState(() {
      _loadOrgsFuture = loadOrgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizations I Follow',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _loadOrgsFuture,
        // The actual page
        builder: (context, snapshot) {
          // If we're still loading student organizations from the server
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
          }
          // If the list of student organizations the user follows is empty
          else if (orgs.isEmpty) {
            return const Center(
              child: Text('You are not following any organizations.'),
            );
          }
          // Otherwise, return a list of student organizations the user follows
          return ListView.separated(
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, height: 0),
            itemCount: orgs.length,
            itemBuilder: (context, index) {
              // A slidable widget for each organization
              return Slidable(
                key: ValueKey(orgs[index].id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  dismissible: DismissiblePane(
                    // Unfollow organization and reset the state of the page
                    // if user dismisses the pane after sliding the card to the left
                    onDismissed: () {
                      unfollowOrg(orgs[index].id);
                      setState(() {
                        orgs.removeAt(index);
                      });
                      // refresh();
                    },
                  ),
                  children: [
                    SlidableAction(
                      // Unfollow organization and reset the state of the page
                      // if user slides the card all the way to the left
                      onPressed: (context) {
                        unfollowOrg(orgs[index].id);
                        orgs.removeAt(index);
                        refresh();
                      },
                      label: 'Unfollow',
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
