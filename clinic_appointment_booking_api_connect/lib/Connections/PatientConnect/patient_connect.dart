import 'dart:convert';
import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/completed_patient_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/login_requirements_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/user_tokens.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_details_dto.dart';
import 'package:dartz/dartz.dart';

class PatientConnect {
  PatientConnect._();

  static Future<Either<String?, ClsUserTokensDto>> addPatient(
    ClsCompletedPatientDto completedPatientDTO,
    ClsLoginRequirementsDto loginRequirementsDTO,
  ) async {
    try {
      final String loginDataJson = jsonEncode(loginRequirementsDTO.toJson());

      DioClient.setLoginData(loginDataJson);

      final result = await DioClient.dio.post(
        'Patient',
        data: completedPatientDTO.toJson(),
      );

      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final userTokens = ClsUserTokensDto.fromJson(data);

          if (userTokens.jwtToken == null || userTokens.refreshToken == null) {
            return Left('Invalid tokens received from server');
          }

          DioClient.setAuthToken(userTokens.jwtToken!);
          DioClient.setRefreshToken(userTokens.refreshToken!);

          return Right(userTokens);
        } else {
          return Left('Invalid response format: Expected user tokens data');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 500) {
        return Left('Server Error: ${result.data}');
      } else {
        return Left('Request failed with status: ${result.statusCode}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, ClsPatientDetailsDto>> getPatientDetails(
    int patientID,
  ) async {
    try {
      if (patientID <= 0) {
        return Left('Invalid patient ID');
      }

      final result = await DioClient.dio.get(
        'Patient/GetPatientDetails/$patientID',
      );

      if (result.statusCode == 200) {
        final patientDetails = ClsPatientDetailsDto.fromJson(result.data);
        return Right(patientDetails);
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Patient not found');
      } else if (result.statusCode == 500) {
        return Left('Server Error: ${result.data}');
      } else {
        return Left('Request failed with status: ${result.statusCode}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
