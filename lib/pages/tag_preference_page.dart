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
      body: ListView.builder(
        itemCount: availableTags.length,
        itemBuilder: (context, index) {
          final tag = availableTags[index];
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
                  print(selectedTags); 
                  updatePrefferedTags(selectedTags); 
                  PREFERREDTAGS = selectedTags;
                });
              },
            ),
          );
        },
      ),
    );
  }
}