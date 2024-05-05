import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}


// adapted from https://medium.com/@kamranzafar128/open-google-map-and-show-navigation-in-flutter-e0cb6c634aae
// for more google map schemes: https://developers.google.com/maps/documentation/urls/ios-urlscheme#swift_4
class MapUtils {
  MapUtils._();
  
  static Future<void> launchGoogleMaps(double destinationLatitude,double destinationLongitude) async {
    // const double destinationLatitude= 31.5204;
    // const double destinationLongitude = 74.3587;
    var googleUrl;

    if (Platform.isAndroid) {
        googleUrl = Uri(
        scheme: "google.navigation",
        queryParameters: {
          'q': '$destinationLatitude, $destinationLongitude'
        });
    } else if (Platform.isIOS) {
      googleUrl = Uri(
        scheme: "comgooglemaps",
        path:'/',
        queryParameters: {
          'daddr': '$destinationLatitude, $destinationLongitude'
        });
    } else {
      throw 'Unsupported platform';}

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      print('An error occurred');
    }
  }
}


class MailUtils {
  MailUtils._();
  
  static Future<void> contactHost(hostEmail, eventTitle) async {
    // All spaces are replaced with %20 to avoid "+"
    String subject = 'Regarding $eventTitle'.replaceAll(' ', '%20');
    String body = 'Hello,\n I am interested in your event $eventTitle.'.replaceAll(' ', '%20');

    Uri url = Uri(
      scheme: 'mailto',
      path: hostEmail,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('An error occurred');
    }
  }
}
