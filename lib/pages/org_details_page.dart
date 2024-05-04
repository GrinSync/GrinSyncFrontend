import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/org_models.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';

class OrgDetailsPage extends StatefulWidget {
  final Org org; // Organization to display details of
    
  @override
  _OrgDetailsPageState createState() => _OrgDetailsPageState();

  // constructor
  OrgDetailsPage({Key? key, required this.org}) : super(key: key);
}

class _OrgDetailsPageState extends State<OrgDetailsPage> {
  // bool _isFollowing = false;
  List<User> leaders = []; // List of student leaders in the organization
  List<Event> events = []; // List of events created by the organization

  @override
  void initState() {
    super.initState();
    initializeLeaders();
    initializeEvents();
  }

  initializeLeaders() async {
    for (int id in widget.org.studentLeaders) {
      User? leader = await getUserByID(id);
    
      if (leader != null) {
        setState(() {
          leaders.add(leader);
        });
      }
    }
}

  initializeEvents() async {
    for (int id in widget.org.orgEvents) {
      Event? event = await getEventByID(id);
      
      if (event != null) {
        setState(() {
          events.add(event);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Org Title
              Text(
                  widget.org.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                  ),
                ),
              
              // Org Email
              Text(widget.org.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
        
              SizedBox(height: 10),
              
              // Student Leaders
              Text(
                  'Leaders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              // Student Leader Cards
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: leaders.length,
                  itemBuilder: (context, index) {
                    return OrgLeaderCard(leader: leaders[index]);
                  },
                ),
              ),

              SizedBox(height: 10),
              // Description
              Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Text(
                    widget.org.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              
              
              // Events Section
              Divider(
                height: 20,
                color: Colors.black,
              ),
              Text(
                  'Events Created by ${widget.org.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
              SizedBox(height: 5),
        
              // Event Card list
              // TODO: implement a scrollable list of event cards here using FutureBuilder?
              // Say no events are created yet if there are no events
              Expanded(
                child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return isLoggedIn() // return different event cards based on user's login status
                                  ? EventCardFavoritable(event: events[index], refreshParent: () => {})
                                  : EventCardPlain(event: events[index], refreshParent: () => {});
                          },
                        ),
              ),
              
              // Follow Button: To be implemented later
              // SizedBox(height: 16),
        
              // if (isLoggedIn())
              //   SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //             backgroundColor: Color.fromARGB(255, 255, 172, 28),
              //             foregroundColor: Colors.black),
              //       onPressed: () {
              //         setState(() {
              //           _isFollowing = !_isFollowing;
              //         });
              //         // TODO: implement follow/unfollow functionality
              //       },
                    
              //       child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrgLeaderCard extends StatelessWidget {
  final User leader;
  const OrgLeaderCard({
    super.key,
    required this.leader,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: InkWell(
        child: Card(
          color: Colors.blue[100],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_box, size: 50),
                Text(leader.firstName),
                Text(leader.lastName),
              ],),
          ),
        ),
        onTap: () {
          //TODO: Implement navigation to UserDetailsPages
        }
      ),
    );
  }
}