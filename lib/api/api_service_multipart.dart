import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl/api/response/generic_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service_multipart.g.dart';

@RestApi(baseUrl: "http://3.7.30.86:8075/")
abstract class ApiServiceMultipart{
  factory ApiServiceMultipart(Dio dio, {String? baseUrl}) = _ApiServiceMultipart;

  @POST("ModernRetailImageInfo/StoreImageSave")
  @MultiPart()
  Future<GenericResponse> uploadImage(@Part(name: 'data') String data, @Part(name: 'attachments') File file,);
}