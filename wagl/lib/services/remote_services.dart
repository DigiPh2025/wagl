import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wagl/services/response_wrapper.dart';

import '../util/ApiClient.dart';


class RemoteServices {
  static var client = http.Client();
  // static const String baseUrl = "http://192.168.1.70:1337/"; //Local
  // static const String baseUrl = "http://192.168.100.43:1337/"; //Local mobile
  static const String baseUrl = "http://api.wagl.io/"; //Live

  static var header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  // Get Method for call Apis
  static Future<http.Response> fetchGetData(String url) async {
    print('URL  :$baseUrl$url');
    print('token  : ${ApiClient.box.read('authToken')}');
    var clients = http.Client();
    try {
      var response = await clients.get(Uri.parse('$baseUrl$url'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
      });
      return response;
    } finally {
      clients.close();
    }
  }

  static Future<http.Response> fetchGetDataWithoutToken(String url) async {
    print('$baseUrl$url');
    var clients = http.Client();
    try {
      var response = await clients.get(Uri.parse('$baseUrl$url'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      return response;
    } finally {
      clients.close();
    }
  }

  // Post Method for call Apis
  static Future<ResponseWrapper> postMethod(String url, Map map) async {
    print("Map:: ${const JsonEncoder().convert(map)}\n\n Url:: $baseUrl$url");
    var h = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h, body: const JsonEncoder().convert(map));
      return _handleResponse(response);
    } finally {}
  }

  static Future<ResponseWrapper> postMethodWithToken(String url, Map map) async {

    print("here the json ${JsonEncoder().convert(map)}");
    print("here the json ${baseUrl+url} ");
    print("here the Bearer ${ApiClient.box.read('authToken')} ");
    var h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': '*/*',
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h, body: const JsonEncoder().convert(map));
      return _handleResponse(response);
    } finally {

    }
  }
  static Future<ResponseWrapper> postMethodWithTokenWithoutMap(String url) async {
    var h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': '*/*',
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h);
      return _handleResponse(response);
    } finally {}
  }

  // Put Method for call Apis
  static Future<ResponseWrapper> fetchPutData(String url,Map map) async {
    print('$baseUrl$url');
    print('${ApiClient.box.read('authToken')}');
    print('$map');
    var client = http.Client();
    try {
      var response = await client.put(Uri.parse('$baseUrl$url'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'

          },
          body: const JsonEncoder().convert(map));
      return _handleResponse(response);
    } finally {
      client.close();
    }
  }

  static Future<ResponseWrapper> fetchPutDataWithoutBody(String url) async {
    var client = http.Client();
    try {
      var response = await client.put(Uri.parse('$baseUrl$url'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
      });
      return _handleResponse(response);
    } finally {
      client.close();
    }
  }

  // Delete Method for call Apis
  static Future<ResponseWrapper> deleteData(String url) async {
    var clients = http.Client();
    try {
      var response = await clients.delete(Uri.parse('$baseUrl$url'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
          },
          );
      return _handleResponse(response);
    } finally {
      clients.close();
    }
  }


  static ResponseWrapper _handleResponse(http.Response response) {
    print("object ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        return ResponseWrapper.success(
          data: response.body,
          statusCode: response.statusCode,
        );
      case 201:
        return ResponseWrapper.success(
          data: response.body,
          statusCode: response.statusCode,
        );
      case 400:
        return ResponseWrapper.error(
          errorMessage: 'Email or Username are already taken',
          statusCode: response.statusCode,
        );
      case 401:
        return ResponseWrapper.error(
          errorMessage: 'Unauthorized. Please check your credentials.',
          statusCode: response.statusCode,
        );
      case 403:
        return ResponseWrapper.error(
          errorMessage: 'Forbidden. You do not have access to this resource.',
          statusCode: response.statusCode,
        );
      case 404:
        return ResponseWrapper.error(
          errorMessage: 'Resource not found.',
          statusCode: response.statusCode,
        );
      case 500:
        return ResponseWrapper.error(
          errorMessage: 'Internal server error. Please try again later.',
          statusCode: response.statusCode,
        );
      default:
        return ResponseWrapper.error(
          errorMessage: 'Unexpected error: ${response.statusCode}.',
          statusCode: response.statusCode,
        );
    }
  }

}
