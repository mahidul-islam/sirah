import 'package:dio/dio.dart';
import 'package:sirah/shared/dio/dio_helper.dart';

final Dio dio = DioHelper.getDio(
    baseUrl: "https://main--flourishing-marigold-3d503b.netlify.app/");
