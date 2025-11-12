import 'package:clinic_appointment_booking_api_connect/Connections/settings/refresh_token_connect.dart';
import 'package:dio/dio.dart';

import 'dart:convert';

class DioClient {
  static DateTime? _getJwtExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('JWT غير صالح');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final payloadBytes = base64Url.decode(normalized);
      final payloadMap = json.decode(utf8.decode(payloadBytes));

      if (payloadMap is Map<String, dynamic> && payloadMap.containsKey('exp')) {
        final exp = payloadMap['exp'] as int;
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isOnRequest) {
      handler.next(options);
      return;
    }
    _isOnRequest = true;

    if (dio.options.headers.containsKey('Authorization')) {
      final auth = dio.options.headers['Authorization'];

      if (auth != null && auth.toString().startsWith('Bearer ')) {
        final jwtToken = auth.toString().substring(7);

        final exp = _getJwtExpiry(jwtToken);

        if (exp != null) {
          if (!DateTime.now().isBefore(exp.add(Duration(minutes: -1)))) {
            final result = await RefreshTokenConnect.login();
            if (result) {
              options.headers['Authorization'] =
                  dio.options.headers['Authorization'];
            }
          }
        }
      }
    }

    _isOnRequest = false;

    handler.next(options);
  }

  DioClient._();

  static bool _isOnRequest = false;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://clinicappintmentbookingalamal.runasp.net/api/',
      validateStatus: (status) {
        return status! <= 500;
      },
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static void initOnRequest() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) async {
          await _onRequest(o, h);
        },
      ),
    );
  }

  static void deleteOnRequest() {
    dio.interceptors.clear();
  }

  static void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void setLoginData(String loginData) {
    dio.options.headers['LoginData'] = loginData;
  }

  static setRefreshToken(String refreshToken) {
    dio.options.headers['RefreshToken'] = refreshToken;
  }

  static void clearHeaders() {
    dio.options.headers.remove('Authorization');
    dio.options.headers.remove('LoginData');
    dio.options.headers.remove('refreshToken');
  }
}
