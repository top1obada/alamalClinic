import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';

class RefreshTokenConnect {
  RefreshTokenConnect._();

  static Future<bool> login() async {
    try {
      final result = await DioClient.dio.get('User/LoginByRefreshToken');

      if (result.statusCode == 200) {
        if (result.data != null) {
          DioClient.setAuthToken(result.data.toString());
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
