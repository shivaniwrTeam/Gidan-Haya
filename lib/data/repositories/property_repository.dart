import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/constant.dart';
import 'package:ebroker/utils/hive_utils.dart';
import 'package:ebroker/data/helper/filter.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/property_model.dart';

class PropertyRepository {
  ///This method will add property
  Future createProperty(
      {required Map<String, dynamic> parameters,
      required CallInfo callInfo}) async {
    var api = Api.apiPostProperty;
    if (parameters['action_type'] == '0') {
      api = Api.apiUpdateProperty;

      if (parameters.containsKey('gallery_images')) {
        if ((parameters['gallery_images'] as List).isEmpty) {
          parameters.remove('gallery_images');
        }
      }

      if (parameters['title_image'] == null ||
          parameters['title_image'] == '') {
        parameters.remove('title_image');
      }
      if (parameters['meta_image'] == null || parameters['meta_image'] == '') {
        parameters.remove('title_image');
      }
    }

    return await Api.post(url: api, parameter: parameters, callInfo: callInfo);
  }

  /// it will get all proerpties
  Future<DataOutput<PropertyModel>> fetchProperty(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<DataOutput<PropertyModel>> fetchRecentProperties(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<DataOutput<PropertyModel>> fetchPropertyFromPropertyId(dynamic id,
      {required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.id: id,
      'current_user': HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<void> deleteProperty(int id, {required CallInfo callInfo}) async {
    await Api.post(
        url: Api.apiUpdateProperty,
        parameter: {Api.id: id, Api.actionType: '1'},
        callInfo: callInfo);
  }

  Future<DataOutput<PropertyModel>> fetchTopRatedProperty(
      {required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.topRated: '1',
      'current_user': HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  ///fetch most viewed properties
  Future<DataOutput<PropertyModel>> fetchMostViewedProperty(
      {required int offset,
      required bool sendCityName,
      required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.topRated: '1',
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId()
    };
    try {
      Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo,
      );

      List<PropertyModel> modelList = (response['data'] as List)
          .map((e) => PropertyModel.fromMap(e))
          .toList();
      return DataOutput(total: response['total'] ?? 0, modelList: modelList);
    } catch (e) {
      throw e;
    }
  }

  ///fetch advertised properties
  Future<DataOutput<PropertyModel>> fetchPromotedProperty(
      {required int offset,
      required bool sendCityName,
      required CallInfo callInfo}) async {
    ///
    Map<String, dynamic> parameters = {
      Api.promoted: true,
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
      url: Api.apiGetProprty,
      queryParameters: parameters,
      callInfo: callInfo,
    );

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(
      total: response['total'] ?? 0,
      modelList: modelList,
    );
  }

  Future<DataOutput<PropertyModel>> fetchNearByProperty(
      {required int offset, required CallInfo callInfo}) async {
    try {
      if (HiveUtils.getCityName() == null ||
          HiveUtils.getCityName().toString().isEmpty) {
        return Future.value(DataOutput(
          total: 0,
          modelList: [],
        ));
      }
      Map<String, dynamic> result = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: {
          'city': HiveUtils.getCityName(),
          Api.offset: offset,
          'limit': Constant.loadLimit,
          'current_user': HiveUtils.getUserId()
        },
        callInfo: callInfo,
      );

      List<PropertyModel> dataList = (result['data'] as List).map((e) {
        return PropertyModel.fromMap(e);
      }).toList();

      return DataOutput<PropertyModel>(
        total: result['total'] ?? 0,
        modelList: dataList,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DataOutput<PropertyModel>> fetchMostLikeProperty(
      {required int offset,
      required bool sendCityName,
      required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      'most_liked': 1,
      'limit': Constant.loadLimit,
      'offset': offset,
      'current_user': HiveUtils.getUserId()
    };
    if (sendCityName) {
      // if (HiveUtils.getCityName() != null) {
      //   if (!Constant.isDemoModeOn) {
      //     parameters['city'] = HiveUtils.getCityName();
      //   }
      // }
    }
    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List).map((e) {
      return PropertyModel.fromMap(e);
    }).toList();
    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<DataOutput<PropertyModel>> fetchMyPromotedProeprties(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      'is_promoted': 1,
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      // "current_user": HiveUtils.getUserId()
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.getAddedProperties,
        queryParameters: parameters,
        callInfo: callInfo);
    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  ///Search proeprty
  Future<DataOutput<PropertyModel>> searchProperty(String searchQuery,
      {required int offset,
      FilterApply? filter,
      required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.search: searchQuery,
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId(),
      ...filter?.getFilter() ?? {}
    };

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();

    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  ///to get my properties which i had added to sell or rent
  Future<DataOutput<PropertyModel>> fetchMyProperties(
      {required int offset,
      required String type,
      required CallInfo callInfo}) async {
    try {
      String? propertyType = _findPropertyType(type.toLowerCase());

      Map<String, dynamic> parameters = {
        Api.offset: offset,
        Api.limit: Constant.loadLimit,
        // Api.userid: HiveUtils.getUserId(),
        Api.propertyType: propertyType,
        // "current_user": HiveUtils.getUserId()
      };
      Map<String, dynamic> response = await Api.get(
        url: Api.getAddedProperties,
        queryParameters: parameters,
        callInfo: callInfo,
      );
      List<PropertyModel> modelList = (response['data'] as List)
          .map((e) => PropertyModel.fromMap(e))
          .toList();

      return DataOutput(total: response['total'] ?? 0, modelList: modelList);
    } catch (e) {
      rethrow;
    }
  }

  String? _findPropertyType(String type) {
    if (type == 'sell') {
      return '0';
    } else if (type == 'rent') {
      return '1';
    }
    return null;
  }

  Future<DataOutput<PropertyModel>> fetchProperyFromCategoryId(
      {required int id,
      required int offset,
      FilterApply? filter,
      bool? showPropertyType,
      required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.categoryId: id,
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
      'current_user': HiveUtils.getUserId(),
      ...filter?.getFilter() ?? {}
    };

    // if (filter != null) {
    //   // parameters.addAll(Constant.propertyFilter!.toMap());
    //   if (Constant.propertyFilter?.categoryId == "") {
    //     if (showPropertyType ?? true) {
    //       parameters.remove(Api.categoryId);
    //     } else {
    //       parameters[Api.categoryId] = id;
    //     }
    //   }
    // }

    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: parameters,
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();
    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<void> setProeprtyView(String propertyId,
      {required CallInfo callInfo}) async {
    await Api.post(
        url: Api.setPropertyView,
        parameter: {Api.propertyId: propertyId},
        callInfo: callInfo);
  }

  Future updatePropertyStatus(
      {required dynamic propertyId,
      required dynamic status,
      required CallInfo callInfo}) async {
    await Api.post(
        url: Api.updatePropertyStatus,
        parameter: {'status': status, 'property_id': propertyId},
        callInfo: callInfo);
  }

  Future<PropertyModel> fetchBySlug(String slug, CallInfo callInfo) async {
    Map<String, dynamic> result = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: {'slug_id': slug},
        callInfo: callInfo);

    return PropertyModel.fromMap(result['data'][0]);
  }

  Future<DataOutput<PropertyModel>> fetchPropertiesFromCityName(String cityName,
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: {
          'city': cityName,
          Api.limit: Constant.loadLimit,
          Api.offset: offset,
          'current_user': HiveUtils.getUserId()
        },
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();
    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }

  Future<DataOutput<PropertyModel>> fetchAllProperties(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> response = await Api.get(
        url: Api.apiGetProprty,
        queryParameters: {
          Api.limit: Constant.loadLimit,
          Api.offset: offset,
        },
        callInfo: callInfo);

    List<PropertyModel> modelList = (response['data'] as List)
        .map((e) => PropertyModel.fromMap(e))
        .toList();
    return DataOutput(total: response['total'] ?? 0, modelList: modelList);
  }
}
