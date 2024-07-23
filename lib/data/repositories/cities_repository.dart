import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/utils/api.dart';

import 'package:ebroker/data/model/city_model.dart';

class CitiesRepository {
  Future<DataOutput<City>> fetchCitiesData({required CallInfo callInfo}) async {
    try {
      Map<String, dynamic> response = await Api.get(
          url: Api.getCitiesData, queryParameters: {}, callInfo: callInfo);
      print('City data response${response}');
      List cities = response['data'];
      List<City> citiesList = cities.map((e) => City.fromMap(e)).toList();
      return DataOutput(total: citiesList.length, modelList: citiesList);
    } catch (e, st) {
      throw st;
      rethrow;
    }
  }
}
