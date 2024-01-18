import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const kURL = 'https://juma-samsa.onrender.com/api/v1';

class NetworkClient {
  static Future<Response> get(
    BuildContext context,
    String endpoint,
  ) async {
    Response response = await http
        .get(
      Uri.parse('$kURL/$endpoint'),
      headers: getHeaders(),
    )
        .timeout(Duration(seconds: 60), onTimeout: () {
      return Response('Сервер не отвечает', 408);
    }).onError(
      (error, stackTrace) => http.Response('error', 500),
    );
    return response;
  }

  static Future<Response> post(BuildContext context, String endpoint,
      {required Map body}) async {
    var response = await http
        .post(Uri.parse('$kURL/$endpoint'),
            headers: getHeaders(), body: jsonEncode(body))
        .timeout(Duration(seconds: 60), onTimeout: () {
      return http.Response('Сервер не отвечает', 408);
    }).onError(
      (error, stackTrace) => http.Response('Ошибка', 500),
    );
    return response;
  }

  static Future<Response> put(BuildContext context, String endpoint,
      {required Map body}) async {
    var response = await http
        .put(Uri.parse('$kURL/$endpoint'),
            headers: getHeaders(), body: jsonEncode(body))
        .timeout(Duration(seconds: 60), onTimeout: () {
      return http.Response('Сервер не отвечает', 408);
    }).onError(
      (error, stackTrace) => http.Response('Ошибка', 500),
    );
    return response;
  }

  static Future<Response> patch(BuildContext context, String endpoint,
      {required Map body}) async {
    var response = await http
        .patch(Uri.parse('$kURL/$endpoint'),
            headers: getHeaders(), body: jsonEncode(body))
        .timeout(Duration(seconds: 60), onTimeout: () {
      return http.Response('Сервер не отвечает', 408);
    }).onError(
      (error, stackTrace) => http.Response('Ошибка', 500),
    );
    return response;
  }

  static Future<Response> delete(BuildContext context, String endpoint) async {
    var response = await http
        .delete(Uri.parse('$kURL/$endpoint'), headers: getHeaders())
        .timeout(Duration(seconds: 60), onTimeout: () {
      return http.Response('Сервер не отвечает', 408);
    }).onError(
      (error, stackTrace) => http.Response('Ошибка', 500),
    );
    return response;
  }
}

Map<String, String> getHeaders() => {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
