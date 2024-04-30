import 'package:flutter/material.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/api/tags.dart';

class TagPreferencePage extends StatefulWidget {
  @override
  _TagPreferencePageState createState() => _TagPreferencePageState();

  TagPreferencePage({Key? key}) : super(key: key);
}

class _TagPreferencePageState extends State<TagPreferencePage> {
  List<String> availableTags = List<String>.from(ALLTAGS);
  List<String> selectedTags = List<String>.from(PREFERREDTAGS);
  int additionalItemNumber = 3;

  @override
  Widget build(BuildContext context) {
    availableTags.sort(); // Sort the tags alphabetically

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tag Preferences',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: availableTags.length + additionalItemNumber,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text('Select tags for homepage feed:',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica'));
            } else if (index == 1) {
              return ListTile(
                title: Text('Select all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      selectedTags = List<String>.from(availableTags);
                      updatePrefferedTags(selectedTags);
                      PREFERREDTAGS = List<String>.from(selectedTags);
                    });
                  },
                ),
              );
            } else if (index == 2) {
              return ListTile(
                title: Text('Deselect all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      selectedTags = [];
                      updatePrefferedTags(selectedTags);
                      PREFERREDTAGS = List<String>.from(selectedTags);
                    });
                  },
                ),
              );
            } else {
              final tag = availableTags[index - additionalItemNumber];
              final isSelected = selectedTags.contains(tag);

              return ListTile(
                title: Text(tag),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                      updatePrefferedTags(selectedTags);
                      PREFERREDTAGS = List<String>.from(selectedTags);
                      print(PREFERREDTAGS);
                    });
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
