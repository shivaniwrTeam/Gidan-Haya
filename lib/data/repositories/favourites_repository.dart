import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/constant.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/property_model.dart';

class FavoriteRepository {
  Future<void> addToFavorite(int id, String type,
      {required CallInfo callInfo}) async {
    Map<String, dynamic> paramerters = {Api.propertyId: id, Api.type: type};

    Map<String, dynamic> map = await Api.post(
        url: Api.addFavourite, parameter: paramerters, callInfo: callInfo);
  }

  Future<void> removeFavorite(int id, {required CallInfo callInfo}) async {
    Map<String, dynamic> paramerters = {
      Api.propertyId: id,
    };

    await Api.post(
        url: Api.removeFavorite, parameter: paramerters, callInfo: callInfo);
  }

  Future<DataOutput<PropertyModel>> fechFavorites(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.offset: offset,
      Api.limit: Constant.loadLimit
    };

    Map<String, dynamic> response = await Api.get(
      url: Api.getFavoriteProperty,
      queryParameters: parameters,
      callInfo: callInfo,
    );

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput<PropertyModel>(
        total: response['total'] ?? 0, modelList: modelList);
  }
}
