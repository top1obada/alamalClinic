import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/doctor_details.dart';
import 'package:dartz/dartz.dart';

class DoctorConnect {
  DoctorConnect._();

  static Future<Either<String?, List<ClsClinicDoctorDto>>> getAllDoctors(
    int pageSize,
    int pageNumber,
  ) async {
    try {
      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final result = await DioClient.dio.get(
        'Doctor/GetAllDoctors/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final doctors =
              data.map((item) => ClsClinicDoctorDto.fromJson(item)).toList();
          return Right(doctors);
        } else {
          return Left('Invalid response format: Expected list of doctors');
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

  static Future<Either<String?, List<ClsClinicDoctorDto>>>
  getDoctorsBySpecialty(
    String? specialtyName,
    int pageSize,
    int pageNumber,
  ) async {
    try {
      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final specialtyParam = specialtyName ?? 'null';

      final result = await DioClient.dio.get(
        'Doctor/GetDoctorsBySpecialty/${Uri.encodeComponent(specialtyParam)}/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final doctors =
              data.map((item) => ClsClinicDoctorDto.fromJson(item)).toList();
          return Right(doctors);
        } else {
          return Left('Invalid response format: Expected list of doctors');
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

  static Future<Either<String?, List<ClsClinicDoctorDto>>> searchDoctorsByName(
    String doctorName,
    int pageSize,
    int pageNumber,
  ) async {
    try {
      if (doctorName.isEmpty) {
        return Left('Doctor name is required');
      }

      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final encodedDoctorName = Uri.encodeComponent(doctorName);

      final result = await DioClient.dio.get(
        'Doctor/SearchByName/$encodedDoctorName/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final doctors =
              data.map((item) => ClsClinicDoctorDto.fromJson(item)).toList();
          return Right(doctors);
        } else {
          return Left('Invalid response format: Expected list of doctors');
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

  static Future<Either<String?, List<ClsClinicDoctorDto>>>
  getPreviousDoctorsAppointments(
    int patientID,
    int pageSize,
    int pageNumber,
  ) async {
    try {
      if (patientID <= 0) {
        return Left('Invalid patient ID');
      }

      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final result = await DioClient.dio.get(
        'Doctor/GetPreviousDoctorsAppointments/$patientID/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final doctors =
              data.map((item) => ClsClinicDoctorDto.fromJson(item)).toList();
          return Right(doctors);
        } else {
          return Left('Invalid response format: Expected list of doctors');
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

  static Future<Either<String?, List<ClsClinicDoctorDto>>>
  getPatientFavoriteDoctors(int patientID, int pageSize, int pageNumber) async {
    try {
      if (patientID <= 0) {
        return Left('Invalid patient ID');
      }

      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final result = await DioClient.dio.get(
        'Doctor/GetPatientFavoriteDoctors/$patientID/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final doctors =
              data.map((item) => ClsClinicDoctorDto.fromJson(item)).toList();
          return Right(doctors);
        } else {
          return Left('Invalid response format: Expected list of doctors');
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

  static Future<Either<String?, ClsDoctorDetailsDto>> getDoctorDetails(
    int doctorID,
  ) async {
    try {
      if (doctorID <= 0) {
        return Left('Invalid doctor ID');
      }

      final result = await DioClient.dio.get(
        'Doctor/GetDoctorDetails/$doctorID',
      );

      if (result.statusCode == 200) {
        final doctorDetails = ClsDoctorDetailsDto.fromJson(result.data);
        return Right(doctorDetails);
      } else if (result.statusCode == 400) {
        return Left('Bad Request: ${result.data}');
      } else if (result.statusCode == 404) {
        return Left('Doctor not found');
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
