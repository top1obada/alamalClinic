import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_status_count_dto.dart';

class ClsPatientDetailsDto {
  DateTime? joiningDate;
  ClsPatientAppointmentStatusCountDto? appointmentStatusCount;

  ClsPatientDetailsDto({this.joiningDate, this.appointmentStatusCount});

  factory ClsPatientDetailsDto.fromJson(Map<String, dynamic> json) {
    return ClsPatientDetailsDto(
      joiningDate:
          json['JoiningDate'] != null
              ? DateTime.parse(json['JoiningDate'] as String)
              : null,
      appointmentStatusCount:
          json['AppointmentStatusCount'] != null
              ? ClsPatientAppointmentStatusCountDto.fromJson(
                json['AppointmentStatusCount'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JoiningDate': joiningDate?.toIso8601String(),
      'AppointmentStatusCount': appointmentStatusCount?.toJson(),
    };
  }
}
