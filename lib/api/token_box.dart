import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test_app/constants.dart';
import 'package:flutter_test_app/global.dart';
import 'package:hive_flutter/hive_flutter.dart';

setTokenBox() async {
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
  BOX = await Hive.openBox(tokenBox,
      encryptionCipher: HiveAesCipher(
          encryptionKeyUint8List)); // save the box in a global variable
}
