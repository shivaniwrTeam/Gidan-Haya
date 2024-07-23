import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/report_property/reason_model.dart';

import 'package:ebroker/utils/api.dart';

class ReportPropertyRepository {
  Future<DataOutput<ReportReason>> fetchReportReasonsList(
      {required CallInfo callInfo}) async {
    try {
      Map<String, dynamic> response = await Api.get(
          url: Api.getReportReasons, queryParameters: {}, callInfo: callInfo);

      List<ReportReason> list = (response['data'] as List).map((e) {
        return ReportReason(id: e['id'], reason: e['reason']);
      }).toList();

      return DataOutput(total: response['total'], modelList: list);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> reportProperty(
      {required int reasonId,
      required int propertyId,
      String? message,
      required CallInfo callInfo}) async {
    return await Api.post(
        url: Api.addReports,
        parameter: {
          'reason_id': (reasonId == -10) ? 0 : reasonId,
          'property_id': propertyId,
          if (message != null) 'other_message': message
        },
        callInfo: callInfo);
  }
}
