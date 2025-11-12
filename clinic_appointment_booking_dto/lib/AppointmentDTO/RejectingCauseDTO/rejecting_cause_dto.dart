class ClsRejectingCauseDto {
  int? appointmentID;
  String? text;
  DateTime? rejectedDate;

  ClsRejectingCauseDto({this.appointmentID, this.text, this.rejectedDate});

  factory ClsRejectingCauseDto.fromJson(Map<String, dynamic> json) {
    return ClsRejectingCauseDto(
      appointmentID: json['AppointmentID'],
      text: json['Text'],
      rejectedDate:
          json['RejectedDate'] != null
              ? DateTime.parse(json['RejectedDate'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointmentID': appointmentID,
      'Text': text,
      'RejectedDate': rejectedDate?.toIso8601String(),
    };
  }
}
