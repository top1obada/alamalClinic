import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:clinic_appointment_booking_dto/AppointmentDTO/available_appointment_times_dto.dart';

class AppointmentConnect {
  AppointmentConnect._();

  static Future<Either<String?, int>> createAppointment(
    ClsAppointmentDto appointmentDTO,
  ) async {
    try {
      if (appointmentDTO.patientID == null || appointmentDTO.patientID! <= 0) {
        return Left('Invalid patient ID');
      }

      if (appointmentDTO.doctorID == null || appointmentDTO.doctorID! <= 0) {
        return Left('Invalid doctor ID');
      }

      if (appointmentDTO.appointmentTime == null) {
        return Left('Appointment time is required');
      }

      final result = await DioClient.dio.post(
        'Appointment',
        data: appointmentDTO.toJson(),
      );

      if (result.statusCode == 200) {
        final appointmentID = result.data as int;
        return Right(appointmentID);
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

  static Future<Either<String?, List<ClsAvailableAppointmentTimeDto>>>
  getAvailableAppointmentTimes(
    ClsAvailableTimeAppointmentsFilterDto filterDto,
  ) async {
    try {
      if (filterDto.doctorID == null || filterDto.doctorID! <= 0) {
        return Left('Invalid doctor ID');
      }

      if (filterDto.date == null || filterDto.date!.isBefore(DateTime.now())) {
        return Left('Invalid date');
      }

      final result = await DioClient.dio.post(
        'Appointment/GetAvailableAppointmentTimes',
        data: filterDto.toJson(),
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final availableTimes =
              data
                  .map((item) => ClsAvailableAppointmentTimeDto.fromJson(item))
                  .toList();
          return Right(availableTimes);
        } else {
          return Left(
            'Invalid response format: Expected list of available times',
          );
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

  static Future<Either<String?, List<ClsPatientAppointmentDto>>>
  getPatientAppointments(int patientID, int pageSize, int pageNumber) async {
    try {
      if (patientID <= 0) {
        return Left('Invalid patient ID');
      }

      if (pageSize <= 0 || pageNumber <= 0) {
        return Left('Page size and page number must be greater than 0');
      }

      final result = await DioClient.dio.get(
        'Appointment/GetPatientAppointments/$patientID/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final appointments =
              data
                  .map((item) => ClsPatientAppointmentDto.fromJson(item))
                  .toList();
          return Right(appointments);
        } else {
          return Left('Invalid response format: Expected list of appointments');
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

  static Future<Either<String?, List<ClsPatientAppointmentDto>>>
  getPatientAppointmentsByStatus(
    int patientID,
    EnAppointmentStatus appointmentStatus,
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
        'Appointment/GetPatientAppointmentsByStatus/$patientID/${appointmentStatus.value}/$pageSize/$pageNumber',
      );

      if (result.statusCode == 200) {
        if (result.data is List) {
          final data = result.data as List;
          final appointments =
              data
                  .map((item) => ClsPatientAppointmentDto.fromJson(item))
                  .toList();
          return Right(appointments);
        } else {
          return Left('Invalid response format: Expected list of appointments');
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
