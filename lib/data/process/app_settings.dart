import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ebroker/app/default_app_setting.dart';
import 'package:ebroker/utils/Queue/queue.dart';
import 'package:ebroker/utils/hive_keys.dart';

class AppSettingsLoadTask extends Task<bool> {
  @override
  Future<bool> process() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      await Hive.openBox(HiveKeys.userDetailsBox);
      await Hive.openBox(HiveKeys.svgBox);
      await Hive.openBox(HiveKeys.themeColorBox);
      await LoadAppSettings().load(false);

      return true;
    } catch (e, st) {
      return false;
    }
  }
}