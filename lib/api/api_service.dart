import 'package:dio/dio.dart';
import 'package:flutter_demo_one/api/api_response.dart';
import 'package:flutter_demo_one/api/login_api_response.dart';
import 'package:flutter_demo_one/api/login_type_req.dart';
import 'package:retrofit/http.dart';

import 'store_type_req.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: "http://3.7.30.86:8075/API/")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("UserLogin/Login")
  Future<LoginApiResponse> doLogin(@Body() LoginTypeReq obj);

  @POST("ModernRetailInfoDetails/StoreTypeLists")
  Future<ApiResponse> getStoreType(@Body() StoreTypeReq obj);
}