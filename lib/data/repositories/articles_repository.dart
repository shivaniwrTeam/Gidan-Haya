import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/constant.dart';
import 'package:ebroker/data/model/article_model.dart';
import 'package:ebroker/data/model/data_output.dart';

class ArticlesRepository {
  Future<DataOutput<ArticleModel>> fetchArticles(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.offset: offset,
      Api.limit: Constant.loadLimit
    };

    Map<String, dynamic> result = await Api.get(
        url: Api.getArticles, queryParameters: parameters, callInfo: callInfo);

    List<ArticleModel> modelList = (result['data'] as List)
        .map((element) => ArticleModel.fromJson(element))
        .toList();

    return DataOutput<ArticleModel>(
        total: result['total'] ?? 0, modelList: modelList);
  }

  Future<ArticleModel> fetchArticlesBySlugId(
      String slug, CallInfo callInfo) async {
    Map<String, dynamic> parameters = {'slug_id': slug};

    Map<String, dynamic> result = await Api.get(
        url: Api.getArticles, queryParameters: parameters, callInfo: callInfo);

    List<ArticleModel> modelList = (result['data'] as List)
        .map((element) => ArticleModel.fromJson(element))
        .toList();

    return modelList.first;
  }
}
