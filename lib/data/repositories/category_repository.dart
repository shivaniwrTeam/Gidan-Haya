import 'dart:developer';

import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/constant.dart';
import 'package:ebroker/data/model/category.dart';
import 'package:ebroker/data/model/data_output.dart';

class CategoryRepository {
  Future<DataOutput<Category>> fetchCategories(
      {required int offset, int? id, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      if (id != null) 'id': id,
      Api.offset: offset,
      Api.limit: Constant.loadLimit,
    };
    try {
      Map<String, dynamic> response = await Api.get(
          url: Api.apiGetCategories,
          queryParameters: parameters,
          callInfo: callInfo);

      List<Category> modelList = (response['data'] as List).map(
        (e) {
          return Category.fromJson(e);
        },
      ).toList();
      return DataOutput(total: response['total'] ?? 0, modelList: modelList);
    } catch (e) {
      throw e;
    }
  }
}
