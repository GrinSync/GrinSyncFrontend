import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test_app/api/tags.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/pages/profile_page.dart';
import 'package:flutter_test_app/pages/event_creation_page.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:flutter_test_app/pages/calendar_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_test_app/pages/search_page.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/global.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  final encryptionKeyString = await secureStorage.read(key: 'key');
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKeyUint8List = base64Url.decode(key!);
  print('Encryption key Uint8List: $encryptionKeyUint8List');
  BOX = await Hive.openBox(tokenBox,
      encryptionCipher: HiveAesCipher(
          encryptionKeyUint8List)); // save the box in a global variable

  await setLoginStatus(); // this function will set the USER global variable to current user if logged in, else null
  await setAllTags(); // this function will set the ALLTAGS global variable to a list of strings of all tags
  await setPrefferedTags(); // this function will set the PREFERREDTAGS global variable to a list of strings of preferred tags
  await setStudentOrgs(); // this function will set the STUDENTORGS global variable to a list of student org ids that the user is linked with
  print('All Init Functions Completed');

  // run the app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrinSync App',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Colors.white,
            height: 30,
            iconTheme:
                MaterialStateProperty.all(IconThemeData(color: Colors.black)),
            labelTextStyle: MaterialStateProperty.resolveWith((state) {
              if (state.contains(MaterialState.selected)) {
                return const TextStyle(color: Colors.white);
              }
              return const TextStyle(color: Colors.black);
            }),
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 218, 41, 28)), // Grinnell Red
          useMaterial3: true,
          fontFamily:
              'Futura' // Futura as the default font, the font used on Grinnell College's website
          ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndexOnHomePage = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    // this switch statement will determine which page to display based on the navigation bar item selected
    // Once the pages are implemented, the Placeholder() widget will be replaced with the actual page widget
    switch (selectedIndexOnHomePage) {
      case 0: // this is the home page where where user can discover events
        currentPage = HomePage();
        break;
      case 1: // this is the search page where user can search for events
        currentPage = SearchPage();
        break;
      case 2: // this is the event creation page where user can create their own events
        currentPage = CreatePage();
        break;
      case 3: // this is the user's agenda (calendar view: month view, week view, day view)
        currentPage = CalendarPage();
        break;
      case 4: // this is user's profile page
        currentPage = ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndexOnHomePage');
    }

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: currentPage, //one of the five pages depending on the navigation bar item selected
              ),
                    NavigationBar(
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      indicatorColor: Colors.white,
                      shadowColor: Colors.white,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.search),
                          label: 'Search',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.add),
                          label: 'Create',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.calendar_month),
                          label: 'Calendar',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                      selectedIndex: selectedIndexOnHomePage,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndexOnHomePage = value;
                        });
                      }),
                    // SizedBox(
                    //   height: 50,
                    //   child: Container(
                    //     color: Colors.white, //Theme.of(context).colorScheme.primary,
                    //   ),
                    // )
                    ]
    );
  }
}
