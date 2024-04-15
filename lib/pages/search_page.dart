import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _keyword;
  int searchMode = 0; // 0 for search event, 1 for search user
  var searchBarLabelText = 'Search Events';
  Icon searchBarIcon = Icon(Icons.search);

  @override
  void initState() {
    _keyword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _keyword,
            autocorrect: true,
            decoration: InputDecoration(
              prefixIcon:
                  searchMode == 0 ? Icon(Icons.event) : Icon(Icons.person),
              labelText:
                  searchMode == 0 ? 'Search for Events' : 'Search for Users',
              hintText: 'Enter a keyword',
              border: OutlineInputBorder(),
            ),
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
        ],
      ),
    ));
  }
}
