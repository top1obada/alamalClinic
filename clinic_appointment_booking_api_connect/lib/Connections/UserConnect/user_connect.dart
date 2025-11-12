import 'dart:convert';
import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/login_requirements_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/user_tokens.dart';

import 'package:dartz/dartz.dart';

class UserConnect {
  UserConnect._();

  static Future<Either<String?, ClsUserTokensDto>> login(
    ClsLoginRequirementsDto loginRequirementsDTO,
  ) async {
    try {
      DioClient.clearHeaders();

      final String loginRequirementJson = jsonEncode(
        loginRequirementsDTO.toJson(),
      );

      DioClient.setLoginData(loginRequirementJson);

      final result = await DioClient.dio.get('User/Login');

      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final tokens = ClsUserTokensDto.fromJson(result.data);

          if (tokens.jwtToken == null) {
            return Left("There Is No JWT Token");
          }

          if (tokens.refreshToken == null) {
            return Left("There Is No Refresh Token");
          }

          DioClient.clearHeaders();
          DioClient.setAuthToken(tokens.jwtToken!);
          DioClient.setRefreshToken(tokens.refreshToken!);

          return Right(tokens);
        } else {
          return Left("Invalid response format: Expected tokens data");
        }
      } else if (result.statusCode == 400) {
        return Left("Bad Request: ${result.data}");
      } else if (result.statusCode == 401) {
        return Left("Unauthorized: ${result.data}");
      } else if (result.statusCode == 500) {
        return Left("Server Error: ${result.data}");
      } else {
        return Left("Request failed with status: ${result.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
