import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/user_authorization.dart';

class OrgDetailsPage extends StatefulWidget {
  @override
  _OrgDetailsPageState createState() => _OrgDetailsPageState();

  const OrgDetailsPage({Key? key}) : super(key: key); // TODO: takes in an org ID or org object
}

class _OrgDetailsPageState extends State<OrgDetailsPage> {
  bool _isFollowing = false;

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
              const Text(
                  '[Organization Title]',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                  ),
                ),
              
              // Org Email
              Text('[example@studentorg.grinnell.edu]',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
        
              SizedBox(height: 16),
           
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
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 100,
                      height: 50,
                      child: InkWell(
                        child: Card(
                          child: Column(
                            children: [
                              Icon(Icons.account_box, size: 50),
                              Text('[Leader $index]'),
                            ],),
                        ),
                        onTap: () {
                          //TODO: Implement navigation to UserDetailsPages
                        }
                      ),
                    );
                  },
                ),
              ),
              
              // Events Section
              Divider(
                height: 25,
                color: Colors.black,
              ),
              Text(
                  'Events Created by [Org name]',
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
                child: Placeholder(),
              ),
              
              // Follow Button
              SizedBox(height: 16),
        
              if (isLoggedIn())
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 172, 28),
                          foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                      // TODO: implement follow/unfollow functionality
                    },
                    
                    child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}