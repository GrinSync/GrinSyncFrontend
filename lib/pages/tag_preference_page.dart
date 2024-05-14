import 'package:flutter/material.dart';
import 'package:grinsync/global.dart';
import 'package:grinsync/api/tags.dart';

class TagPreferencePage extends StatefulWidget {
  @override
  _TagPreferencePageState createState() => _TagPreferencePageState();

  const TagPreferencePage({super.key});
}

class _TagPreferencePageState extends State<TagPreferencePage> {
  List<String> availableTags =
      List<String>.from(ALLTAGS); // List of all available tags
  List<String> selectedTags =
      List<String>.from(PREFERREDTAGS); // List of selected tags
  int additionalItemNumber =
      3; // Number of additional items in the listviewbuilder (title, select all, deselect all)

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
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: ListView.builder(
          itemCount: availableTags.length + additionalItemNumber,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Title
              return const Text('Select tags for homepage feed:',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica'));
            } else if (index == 1) {
              // Select all
              return ListTile(
                title: const Text('Select all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
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
              // Deselect all
              return ListTile(
                title: const Text('Deselect all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
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
              // Tags
              final tag =
                  availableTags[index - additionalItemNumber]; // Get the tag
              final isSelected =
                  selectedTags.contains(tag); // Check if the tag is selected

              return ListTile(
                title: Text(tag),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (selected) {
                    // Update the selected tags
                    setState(() {
                      if (selected!) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                      updatePrefferedTags(
                          selectedTags); // Update the preferred tags to the server
                      PREFERREDTAGS = List<String>.from(
                          selectedTags); // Update the preferred tags locally
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
