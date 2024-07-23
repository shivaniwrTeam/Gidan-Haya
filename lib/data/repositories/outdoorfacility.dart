import 'package:ebroker/utils/api.dart';
import 'package:ebroker/data/model/outdoor_facility.dart';

class OutdoorFacilityRepository {
  Future<List<OutdoorFacility>> fetchOutdoorFacilityList(
      {required CallInfo callInfo}) async {
    Map<String, dynamic> result = await Api.get(
        url: Api.getOutdoorFacilites, queryParameters: {}, callInfo: callInfo);

    List<OutdoorFacility> outdoorFacilities =
        (result['data'] as List).map((element) {
      return OutdoorFacility.fromJson(element);
    }).toList();

    return List.from(outdoorFacilities);
  }
}
