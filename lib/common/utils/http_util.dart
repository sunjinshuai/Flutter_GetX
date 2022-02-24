import 'dart:io';
import 'package:dio/dio.dart';

enum HttpMethod {
  GET,
  PUT,
  POST,
  PATCH,
  DELETE,
  UPLOAD,
}

class HttpUtil {
  static Dio? _dioInstance;
  static Dio getDioInstance() {
    if (_dioInstance == null) {
      _dioInstance = Dio();
    }
    return _dioInstance!;
  }

  static Future get(String url,
      {Map<String, dynamic>? queryParams, CancelToken? cancelToken}) async {
    return await sendRequest(HttpMethod.GET, url,
        queryParams: queryParams, cancelToken: cancelToken);
  }

  static Future put(String url,
      {Map<String, dynamic>? queryParams, dynamic data}) async {
    return await sendRequest(HttpMethod.PUT, url,
        queryParams: queryParams, data: data);
  }

  static Future post(String url,
      {Map<String, dynamic>? queryParams,
      dynamic data,
      CancelToken? cancelToken}) async {
    return await sendRequest(HttpMethod.POST, url,
        queryParams: queryParams, data: data, cancelToken: cancelToken);
  }

  static Future patch(String url,
      {Map<String, dynamic>? queryParams, dynamic data}) async {
    return await sendRequest(HttpMethod.PATCH, url,
        queryParams: queryParams, data: data);
  }

  static Future delete(String url,
      {Map<String, dynamic>? queryParams, dynamic data}) async {
    return await sendRequest(HttpMethod.DELETE, url,
        queryParams: queryParams, data: data);
  }

  static Future uploadSingle(String url, String fileKey, File file,
      {Map<String, dynamic>? queryParams}) async {
    FormData formData = FormData.fromMap({
      fileKey: await MultipartFile.fromFile(file.path),
    });
    return await sendRequest(HttpMethod.POST, url,
        queryParams: queryParams, data: formData);
  }

  static Future<Response?> sendRequest(HttpMethod method, String url,
      {Map<String, dynamic>? queryParams,
      dynamic data,
      CancelToken? cancelToken}) async {
    try {
      switch (method) {
        case HttpMethod.GET:
          return await HttpUtil.getDioInstance()
              .get(url, queryParameters: queryParams, cancelToken: cancelToken);
        case HttpMethod.PUT:
          return await HttpUtil.getDioInstance().put(url,
              queryParameters: queryParams,
              data: data,
              cancelToken: cancelToken);
        case HttpMethod.POST:
          return await HttpUtil.getDioInstance().post(url,
              queryParameters: queryParams,
              data: data,
              cancelToken: cancelToken);
        case HttpMethod.PATCH:
          return await HttpUtil.getDioInstance().patch(url,
              queryParameters: queryParams,
              data: data,
              cancelToken: cancelToken);
        case HttpMethod.DELETE:
          return await HttpUtil.getDioInstance().delete(url,
              queryParameters: queryParams,
              data: data,
              cancelToken: cancelToken);
        default:
          print('请求方式错误');
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print(e.message);
      } else {
        if (e.response != null) {
          _handleErrorResponse(e.response!);
        } else {
          print(e.message);
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }

    return null;
  }

  static void _handleErrorResponse(Response response) {
    switch (response.statusCode) {
      case 401:
        print('验票失败!');
        break;
      case 403:
        print('无权限访问!');
        break;
      case 404:
        print('404未找到!');
        break;
      case 500:
      case 502:
        print('服务器内部错误!');
        break;
      default:
        print(response.statusMessage ?? '请求失败');
    }
  }
}
