class ClsAvailableTimeAppointmentsFilterDto {
  DateTime? date;
  int? doctorID;

  ClsAvailableTimeAppointmentsFilterDto({this.date, this.doctorID});

  factory ClsAvailableTimeAppointmentsFilterDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsAvailableTimeAppointmentsFilterDto(
      date: json['Date'] != null ? DateTime.parse(json['Date']) : null,
      doctorID: json['DoctorID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'Date': date?.toIso8601String(), 'DoctorID': doctorID};
  }
}

class ClsAvailableAppointmentTimeDto {
  String? availableTime;

  ClsAvailableAppointmentTimeDto({this.availableTime});

  factory ClsAvailableAppointmentTimeDto.fromJson(Map<String, dynamic> json) {
    return ClsAvailableAppointmentTimeDto(availableTime: json['AvailableTime']);
  }

  Map<String, dynamic> toJson() {
    return {'AvailableTime': availableTime};
  }
}
