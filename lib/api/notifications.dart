import 'package:grinsync/constants.dart';
import 'package:grinsync/global.dart';

/// get notifications setting from the box
bool getNotificationsSetting() {
  final notificationsSetting = BOX.get(notificationsSettingKey);
  if (notificationsSetting == null) {
    return false;
  }
  return notificationsSetting;
}

/// set notifications setting in the box
Future<void> setNotificationsSetting(bool value) async {
  await BOX.put(notificationsSettingKey, value);
}

class NotificationService {}
