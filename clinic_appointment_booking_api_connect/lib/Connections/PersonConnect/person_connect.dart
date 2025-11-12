import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:dartz/dartz.dart';

class PersonConnect {
  PersonConnect._();

  static Future<Either<String?, ClsPersonDto>> getPerson(int personID) async {
    try {
      // Validate required fields
      if (personID <= 0) {
        return Left('Invalid Person ID');
      }

      // Make the API call
      final result = await DioClient.dio.get('Person/$personID');

      // Handle different response status codes
      if (result.statusCode == 200) {
        if (result.data is Map<String, dynamic>) {
          final data = result.data as Map<String, dynamic>;
          final person = ClsPersonDto.fromJson(data);
          return Right(person);
        } else {
          return Left('Invalid response format: Expected person data');
        }
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Person not found');
      } else if (result.statusCode == 500) {
        return Left('Server Error: ${result.data}');
      } else {
        return Left('Request failed with status: ${result.statusCode}');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String?, bool>> updatePerson(
    ClsPersonDto personDTO,
  ) async {
    try {
      // Validate required fields
      if (personDTO == null) {
        return Left('Person data is required');
      }

      // Make the API call
      final result = await DioClient.dio.put(
        'Person',
        data: personDTO.toJson(),
      );

      // Handle different response status codes
      if (result.statusCode == 200) {
        return Right(true);
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Person not found');
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
