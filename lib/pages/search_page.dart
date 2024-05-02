import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/search_results_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _query =
      TextEditingController(); //text box for search
  int searchMode = 0; // 0 for search event, 1 for search user
  ValueNotifier eventSearchResults = ValueNotifier<List<Event>?>(null);
  //ValueNotifier<List<User>?>? _userSearchResults;
  late List<Event> events;
  Future? _searchEventsFuture;

  @override
  void initState() {
    _query = TextEditingController();
    super.initState();
  }

  Future<void> searchEvents() async {
    eventSearchResults.value = await getSearchedEvents(_query.text);
  }

  refresh() {
    setState(() {
      _searchEventsFuture = searchEvents();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        // Remove the comment when we have the user search functionality
        // actions:[
        //   PopupMenuButton(
        //     itemBuilder: (BuildContext context) => [
        //       const PopupMenuItem(
        //         child: Text('Search Events'),
        //         value: 0,
        //       ),
        //       const PopupMenuItem(
        //         child: Text('Search Users'),
        //         value: 1,
        //       ),
        //     ],
        //     onSelected: (int value) {
        //       setState(() {
        //         searchMode = value;
        //       });
        //     },
        //   ),
        // ]
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _query,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: searchMode == 0
                          ? const Icon(Icons.event)
                          : const Icon(Icons.person),
                      labelText: searchMode == 0
                          ? 'Search for Events'
                          : 'Search for Users',
                      hintText: 'Enter a keyword',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           SearchResultsPage(todo: _query.text)),
                    // );
                    if (_query.text.isNotEmpty) {
                      if (searchMode == 0)
                        setState(() {
                          searchEvents();
                        });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _query.text.isEmpty? 
              const Center(
                child: Text('Search Something...'),
              ) 
              :FutureBuilder(
                future: searchMode == 0? _searchEventsFuture : null, //userSearchResults will be added later
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Search Something...'),
                    );
                  } else {
                    return ValueListenableBuilder(
                      valueListenable: searchMode == 0? eventSearchResults : eventSearchResults, //userSearchResults will be added later
                      builder: (context, searchResult, child) {
                        return ListView.builder(
                          itemCount: searchResult.length + 1,
                          itemBuilder: (context, index) {
                            if (index == searchResult.length) {
                                return Column(
                                  children: [
                                    Divider(color: Colors.grey[400]),
                                    Text('--End of Search Result--',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    Text('Event Count: ${searchResult.length}',
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                  ],
                                );
                              } else {
                                return isLoggedIn()
                                    ? EventCardFavoritable(
                                        event: searchResult[index], refreshParent: refresh)
                                    : EventCardPlain(event: searchResult[index], refreshParent: refresh);
                              }
                          },
                        );
                      }
                    );
                  }
                },
              ),
        ),
          ],
        ),
      ),
    );
  }
}