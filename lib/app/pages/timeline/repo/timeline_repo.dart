import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:sirah/shared/constants.dart';
import 'package:sirah/shared/dio/dio_helper.dart';
import 'package:sirah/shared/dio/global_dio.dart' as global;
import 'package:sirah/app/pages/timeline/model/timeline.dart';

abstract class TimelineApi {
  Future<Either<String, Timeline>> getTopicList({required bool forceRefresh});
}

class HttpTimelineApi implements TimelineApi {
  @override
  Future<Either<String, Timeline>> getTopicList(
      {required bool forceRefresh}) async {
    const String _url = 'topic_list.json';
    final Options options =
        await DioHelper.getDefaultOptions(forceRefresh: forceRefresh);
    try {
      final Response<dynamic> response =
          await global.dio.get(_url, options: options);
      final Timeline profileResponse =
          Timeline(data: json.encode(response.data).toString());
      return Right<String, Timeline>(profileResponse);
    } catch (e) {
      return Left<String, Timeline>(e.toString());
    }
  }
}

class MockTimelineApi implements TimelineApi {
  @override
  Future<Either<String, Timeline>> getTopicList(
      {required bool forceRefresh}) async {
    return Right<String, Timeline>(
      Timeline(
        data: await rootBundle.loadString(JsonPath.json_home_page),
      ),
    );
  }
}
