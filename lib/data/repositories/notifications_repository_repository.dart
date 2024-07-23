import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/constant.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/notification_data.dart';

class NotificationsRepository {
  Future<DataOutput<NotificationData>> fetchNotifications(
      {required int offset, required CallInfo callInfo}) async {
    try {
      Map<String, dynamic> parameters = {
        // Api.userid: HiveUtils.getUserId(),
        Api.offset: offset,
        Api.limit: Constant.loadLimit
      };
      Map<String, dynamic> response = await Api.get(
        url: Api.apiGetNotifications,
        queryParameters: parameters,
        callInfo: callInfo,
      );

      List<NotificationData> modelList = (response['data'] as List).map((e) {
        return NotificationData.fromJson(e);
      }).toList();

      return DataOutput(
        total: 0,
        modelList: modelList,
      );
    } catch (e) {
      rethrow;
    }
  }
}
