import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:dartz/dartz.dart';

class DoctorSpecialtyConnect {
  DoctorSpecialtyConnect._();

  static Future<Either<String?, List<String>>> getDoctorSpecialties() async {
    try {
      final result = await DioClient.dio.get('DoctorSpecialty/GetAll');

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final specialties = data.map((item) => item.toString()).toList();
          return Right(specialties);
        } else {
          return Left('Invalid response format: Expected list of specialties');
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
}
