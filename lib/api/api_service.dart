import 'dart:io';

import 'package:dio/dio.dart';
import 'package:modern_retail/api/response/ProductRateResponse.dart';
import 'package:modern_retail/api/response/branch_response.dart';
import 'package:modern_retail/api/response/generic_response.dart';
import 'package:modern_retail/api/response/login_request.dart';
import 'package:modern_retail/api/response/login_response.dart';
import 'package:modern_retail/api/response/product_response.dart';
import 'package:modern_retail/api/response/state_pin_response.dart';
import 'package:modern_retail/api/response/store_response.dart';
import 'package:modern_retail/api/response/store_save_request.dart';
import 'package:modern_retail/api/response/store_type_response.dart';
import 'package:modern_retail/api/response/user_id_request.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: "http://3.7.30.86:8075/API/")
abstract class ApiService{
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST("UserLogin/Login")
  Future<LoginResponse> doLogin(@Body() LoginRequest obj);

  @POST("ModernRetailInfoDetails/StoreTypeLists")
  Future<StoreTypeResponse> getStoreType(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/StoreInfoFetchLists")
  Future<StoreResponse> getStore(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/PinCityStateLists")
  Future<StatePinResponse> getStatePin(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/ProductDetailLists")
  Future<ProductResponse> getProduct(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/ProductRateLists")
  Future<ProductRateResponse> getProductRate(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/UserBranchLists")
  Future<BranchResponse> getBranch(@Body() UserIdRequest obj);

  @POST("ModernRetailInfoDetails/StoreInfoSave")
  Future<GenericResponse> saveStoreInfo(@Body() StoreSaveRequest input);

  @POST("ModernRetailInfoDetails/StoreInfoEdit")
  Future<GenericResponse> editStoreInfo(@Body() StoreSaveRequest input);
}