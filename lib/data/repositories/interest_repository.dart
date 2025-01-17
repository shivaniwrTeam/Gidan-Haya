import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/interested_user_model.dart';

import 'package:ebroker/utils/api.dart';

class InterestRepository {
  ///this method will set if we are interested in any category when we click intereseted
  Future<void> setInterest(
      {required String propertyId,
      required String interest,
      required CallInfo callInfo}) async {
    await Api.post(
        url: Api.interestedUsers,
        parameter: {
          Api.type: interest,
          Api.propertyId: propertyId,
        },
        callInfo: callInfo);
  }

  Future<DataOutput<InterestedUserModel>> getInterestUser(String propertyId,
      {required int offset, required CallInfo callInfo}) async {
    try {
      Map<String, dynamic> response = await Api.get(
          url: Api.getInterestedUsers,
          queryParameters: {
            'property_id': propertyId,
          },
          callInfo: callInfo);
      List<InterestedUserModel> interestedUserList = (response['data'] as List)
          .map((e) => InterestedUserModel.fromJson(e))
          .toList();

      return DataOutput(
          total: response['total'] ?? 0, modelList: interestedUserList);
    } catch (e) {
      throw e;
    }
  }
}
