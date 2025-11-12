import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';

class ClsChangeAppointmentStatusDto {
  int? appointementID;
  EnAppointmentStatus? appointmentStatus;

  ClsChangeAppointmentStatusDto({this.appointementID, this.appointmentStatus});

  factory ClsChangeAppointmentStatusDto.fromJson(Map<String, dynamic> json) {
    return ClsChangeAppointmentStatusDto(
      appointementID: json['AppointementID'],
      appointmentStatus: EnAppointmentStatus.fromValue(
        json['AppointmentStatus'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointementID': appointementID,
      'AppointmentStatus': appointmentStatus?.value,
    };
  }
}
