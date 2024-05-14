import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/tags.dart';
import 'package:flutter_test_app/api/token_box.dart';
import 'package:flutter_test_app/pages/profile_page.dart';
import 'package:flutter_test_app/pages/event_creation_page.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:flutter_test_app/pages/calendar_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_test_app/pages/search_page.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/api/get_student_orgs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initializations
  await Hive.initFlutter(); // initialize Hive
  await setTokenBox(); // this function will set the BOX global variable to the encrypted token box
  await setLoginStatus(); // this function will set the USER global variable to current user if logged in, else null
  await setAllTags(); // this function will set the ALLTAGS global variable to a list of strings of all tags
  await setPrefferedTags(); // this function will set the PREFERREDTAGS global variable to a list of strings of preferred tags
  await setStudentOrgs(); // this function will set the STUDENTORGS global variable to a list of student org ids that the user is linked with

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

    /// Close token box when app is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrinSync App',
      // This theme will be used throughout the app
      theme: ThemeData(
          // The themedata of navigation bar
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Colors.white,
            height: MediaQuery.of(context).size.height * 0.07,
            iconTheme: MaterialStateProperty.all(
                const IconThemeData(color: Colors.black)),
            labelTextStyle: MaterialStateProperty.resolveWith((state) {
              if (state.contains(MaterialState.selected)) {
                return const TextStyle(color: Colors.white);
              }
              return const TextStyle(color: Colors.black);
            }),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
          // The color scheme of the app, which comes from: https://www.grinnell.edu/about/leadership/offices-services/communications/our-brand/visuals
          colorScheme: ColorScheme.fromSeed(
              seedColor:
                  const Color.fromARGB(255, 218, 41, 28)), // Grinnell Red
          useMaterial3: true,
          fontFamily:
              'Futura' // Futura as the default font, the font used on Grinnell College's website
          ),
      // This is the only page that will be displayed on the screen (other pages will be displayed based on the navigation bar item selected)
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This variable will keep track of the navigation bar item selected
  // The default value is 0, which is the home page (upcoming events page)
  var selectedIndexOnHomePage = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    // This switch statement will determine which page to display based on the navigation bar item selected
    // Once the pages are implemented, the Placeholder() widget will be replaced with the actual page widget
    switch (selectedIndexOnHomePage) {
      case 0: // this is the home page where where user can discover events
        currentPage = const HomePage();
        break;
      case 1: // this is the search page where user can search for events/users/organizations
        currentPage = const SearchPage();
        break;
      case 2: // this is the event creation page where user can create their own events
        currentPage = const CreatePage();
        break;
      case 3: // this is the user's agenda (calendar view: month view, week view, day view)
        currentPage = const CalendarPage();
        break;
      case 4: // this is user's profile page
        currentPage = const ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndexOnHomePage');
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child:
            currentPage, //one of the five pages depending on the navigation bar item selected
      ),
      NavigationBar(
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Colors.white,
          shadowColor: Colors.white,
          destinations: const [
            NavigationDestination(
              // Icon and Label for Home Page in Navigation Bar
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              // Icon and Label for Search Page in Navigation Bar
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              // Icon and Label for Create Event Page in Navigation Bar
              icon: Icon(Icons.add),
              label: 'Create',
            ),
            NavigationDestination(
              // Icon and Label for Calendar Page in Navigation Bar
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            NavigationDestination(
              // Icon and Label for Profile Page in Navigation Bar
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedIndex: selectedIndexOnHomePage,
          onDestinationSelected: (value) {
            setState(() {
              // This will change the navigation bar item selected
              selectedIndexOnHomePage = value;
            });
          }),
    ]);
  }
}
