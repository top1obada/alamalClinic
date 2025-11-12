import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';

class ClsPatientAppointmentDto {
  EnAppointmentStatus? appointmentStatus;
  DateTime? appointmentTime;
  int? doctorID;
  String? doctorFullName;
  String? specialtiesName;

  ClsPatientAppointmentDto({
    this.appointmentStatus,
    this.appointmentTime,
    this.doctorID,
    this.doctorFullName,
    this.specialtiesName,
  });

  factory ClsPatientAppointmentDto.fromJson(Map<String, dynamic> json) {
    return ClsPatientAppointmentDto(
      appointmentStatus: EnAppointmentStatus.fromValue(
        json['AppointmentStatus'],
      ),
      appointmentTime:
          json['AppointmentTime'] != null
              ? DateTime.parse(json['AppointmentTime'])
              : null,
      doctorID: json['DoctorID'],
      doctorFullName: json['DoctorFullName'],
      specialtiesName: json['SpecialtiesName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointmentStatus': appointmentStatus?.value,
      'AppointmentTime': appointmentTime?.toIso8601String(),
      'DoctorID': doctorID,
      'DoctorFullName': doctorFullName,
      'SpecialtiesName': specialtiesName,
    };
  }
}
