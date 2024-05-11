import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/global.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Function to initialize key and token box. Runs on app startup.
setTokenBox() async {
  // Storage to store key which opens token box
  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  final encryptionKeyString = await secureStorage.read(key: 'key');
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey(); // Generate key
    await secureStorage.write( // Save Key
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key'); // Read Key
  final encryptionKeyUint8List = base64Url.decode(key!); // Decode Key
  BOX = await Hive.openBox(tokenBox,
      encryptionCipher: HiveAesCipher(
          encryptionKeyUint8List)); // save the box in a global variable
}
