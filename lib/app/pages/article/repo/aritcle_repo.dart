import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sirah/shared/dio/dio_helper.dart';
import 'package:sirah/shared/dio/global_dio.dart' as global;

abstract class ArticleApi {
  Future<Either<String, String>> getTopicDetails(
      {required bool forceRefresh, required String path});
}

class HttpArticleApi implements ArticleApi {
  @override
  Future<Either<String, String>> getTopicDetails(
      {required bool forceRefresh, required String path}) async {
    String _url = 'articles/' + path;
    final Options options =
        await DioHelper.getDefaultOptions(forceRefresh: forceRefresh);
    try {
      final Response<dynamic> response =
          await global.dio.get(_url, options: options);
      final String profileResponse = response.data;
      return Right<String, String>(profileResponse);
    } catch (e) {
      return Left<String, String>(e.toString());
    }
  }
}

class MockArticleApi implements ArticleApi {
  @override
  Future<Either<String, String>> getTopicDetails(
      {required bool forceRefresh, required String path}) async {
    return const Right<String, String>('');
  }
}
