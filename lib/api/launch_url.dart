import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Function to launch the passed url from the app
Future<void> urlLauncher(Uri url) async {
  if (!await launchUrl(url)) {
    // If url launch failed, throw exception
    throw Exception('Could not launch $url');
  }
}

// adapted from https://medium.com/@kamranzafar128/open-google-map-and-show-navigation-in-flutter-e0cb6c634aae
// for more google map schemes: https://developers.google.com/maps/documentation/urls/ios-urlscheme#swift_4
class MapUtils {
  MapUtils._();

  /// Function to launch google maps on native platform
  static Future<void> launchGoogleMaps(
      double destinationLatitude, double destinationLongitude) async {
    Uri googleUrl;

    if (Platform.isAndroid) {
      // If on android, use native google maps to navigate
      googleUrl = Uri(scheme: "google.navigation", queryParameters: {
        'q': '$destinationLatitude, $destinationLongitude'
      });
    } else if (Platform.isIOS) {
      // If on ios, open google maps
      googleUrl = Uri(scheme: "comgooglemaps", path: '/', queryParameters: {
        'daddr': '$destinationLatitude, $destinationLongitude'
      });
    } else {
      throw 'Unsupported platform';
    }

    if (await canLaunchUrl(googleUrl)) {
      // if url can be launched from the app, launch the url
      await launchUrl(googleUrl);
    }
  }
}

class MailUtils {
  MailUtils._();

  /// Function to open mail to email host of event
  static Future<void> contactHost(hostEmail, eventTitle) async {
    // All spaces are replaced with %20 to avoid "+"
    String subject = 'Regarding $eventTitle'.replaceAll(' ', '%20');
    String body = 'Hello,\n I am interested in your event $eventTitle.'
        .replaceAll(' ', '%20');

    Uri url = Uri(
      // url to open email from app
      scheme: 'mailto',
      path: hostEmail,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(url)) {
      // if url can be launched from the app, launch the url
      await launchUrl(url);
    }
  }
}
