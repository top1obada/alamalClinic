import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_api_connect/Connections/settings/refresh_token_connect.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/store_Tokens.dart';
import 'package:clinic_appointment_booking_providers/StaticLibraries/jwt_token_helper.dart';

class PVRefreshToken extends PVBaseCurrentLoginInfo {
  Future<bool> login() async {
    final tokens = await StoreTokensService.read();

    if (tokens == null) return false;

    DioClient.setRefreshToken(tokens['refreshToken']!);

    final result = await RefreshTokenConnect.login();

    if (result) {
      String jWTToken = DioClient.dio.options.headers['Authorization'];

      retrivingLoggedInDTO = ClsJWTTokenHelper.extractLoginInfoFromToken(
        jWTToken,
      );

      await StoreTokensService.save(jWTToken, tokens['refreshToken']!);

      DioClient.initOnRequest();

      return true;
    } else {
      await StoreTokensService.clear();

      DioClient.clearHeaders();

      return false;
    }
  }
}
