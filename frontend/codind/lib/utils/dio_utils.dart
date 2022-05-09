import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'toast_utils.dart';

// ignore: constant_identifier_names
const __ok_code__ = 20000;

@Deprecated("unused class")
class ResponseInterceptors extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var responseJson = response.data;
    if (responseJson.runtimeType == String) {
      responseJson = jsonDecode(responseJson);
    }
    CommonResponse commenResponse = CommonResponse.fromJson(responseJson);
    var _resultCode = commenResponse.code;

    if (_resultCode != __ok_code__) {
      showToastMessage(commenResponse.message ?? "未知错误", null,
          color: Colors.orange);
      return super.onResponse(response, handler);
    } else {
      return super.onResponse(response, handler);
    }
  }
}

class DioUtils {
  // ignore: prefer_final_fields
  static DioUtils _instance = DioUtils._internal();
  factory DioUtils() => _instance;
  Dio? _dio;

  DioUtils._internal() {
    _dio ??= Dio();
  }

  ///get请求方法
  get(url, {params, options, cancelToken}) async {
    try {
      Response response = await _dio!.get(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
      return response;
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
      return null;
    }
  }

  ///put请求方法
  put(url, {data, params, options, cancelToken}) async {
    try {
      Response response = await _dio!.put(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      return response;
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
      return null;
    }
  }

  ///post请求
  post(url, {data, params, options, cancelToken}) async {
    try {
      Response response = await _dio!.post(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      return response;
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
      return null;
    }
  }

  //取消请求
  cancleRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      showToastMessage("连接超时", null, color: Colors.orange);
    } else if (e.type == DioErrorType.sendTimeout) {
      showToastMessage("请求超时", null, color: Colors.orange);
    } else if (e.type == DioErrorType.receiveTimeout) {
      showToastMessage("响应超时", null, color: Colors.orange);
    } else if (e.type == DioErrorType.response) {
      showToastMessage("返回结果异常", null, color: Colors.orange);
    } else if (e.type == DioErrorType.cancel) {
      showToastMessage("请求取消", null, color: Colors.orange);
    } else {
      showToastMessage("无法连接服务器", null, color: Colors.orange);
    }
  }
}

@Deprecated("unused class")
class CommonResponse {
  int? code;
  dynamic data;
  String? message;

  CommonResponse({this.code, this.data});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}
