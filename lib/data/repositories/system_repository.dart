import 'package:ebroker/exports/main_export.dart';

class SystemRepository {
  Future<Map> fetchSystemSettings(
      {required bool isAnonymouse, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {};

    ///Passing user id here because we will hide sensitive details if there is no user id,
    ///With user id we will get user subscription package details

    Map<String, dynamic> response = await Api.post(
        url: Api.apiGetSystemSettings,
        parameter: parameters,
        useAuthToken: !isAnonymouse,
        callInfo: callInfo);

    return response;
  }
}
