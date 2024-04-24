import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/models/user_models.dart';
import 'package:flutter_test_app/pages/search_results_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _query = TextEditingController(); //text box for search
  int searchMode = 0; // 0 for search event, 1 for search user
  Future<List<Event>?>? _eventSearchResults;
  Future<List<User>?>? _userSearchResults;


  @override
  void initState() {
    _query = TextEditingController();
    super.initState();
  }

  Future<void> search() async {
    if (searchMode == 0) {
      setState(() {
        _eventSearchResults = searchEvents(_query.text);
      });
    } else {
      // search for users
    }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _query,
                  autocorrect: true,
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
                Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => SearchResultsPage(todo: _query.text)),
                          );
                },
              ),
            ],
          ),
          DropdownButton(
            value: searchMode,
            items: <DropdownMenuItem<int>>[
              const DropdownMenuItem(
                child: Text('Search Events'),
                value: 0,
              ),
              const DropdownMenuItem(
                child: Text('Search Users'),
                value: 1,
              ),
            ],
            onChanged: (int? value) {
              setState(() {
                searchMode = value!;
              });
            },
          ),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>?>(
          //     valueListenable: searchResults,
          //     builder: (context, value, child) {
          //       if (value == null) {
          //         return Expanded(child: SizedBox());
          //       } else {
          //         return FutureBuilder(
          //           future: search, 
          //           builder: builder
          //           );
          //       }
          //     },
          //   ),
          //   )
        ],
      ),
    );
  }
}
