import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/user_dto.dart';

import 'patient_dto.dart';

class ClsCompletedPatientDto {
  ClsPersonDto? person;
  ClsUserDto? user;
  ClsPatientDto? patient;

  ClsCompletedPatientDto({this.person, this.user, this.patient});

  factory ClsCompletedPatientDto.fromJson(Map<String, dynamic> json) {
    return ClsCompletedPatientDto(
      person:
          json['Person'] != null ? ClsPersonDto.fromJson(json['Person']) : null,
      user: json['User'] != null ? ClsUserDto.fromJson(json['User']) : null,
      patient:
          json['Patient'] != null
              ? ClsPatientDto.fromJson(json['Patient'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Person': person?.toJson(),
      'User': user?.toJson(),
      'Patient': patient?.toJson(),
    };
  }
}
