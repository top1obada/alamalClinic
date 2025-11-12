enum EnAppointmentStatus {
  ePending(1),
  eConfirmed(2),
  eRejected(3),
  eCancelled(4),
  eCompleted(5);

  final int value;

  const EnAppointmentStatus(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnAppointmentStatus? fromValue(int? value) {
    if (value == null) return null;
    return EnAppointmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse:
          () => throw Exception('Unknown EnAppointmentStatus value: $value'),
    );
  }
}

class ClsAppointmentDto {
  int? appointmentID;
  DateTime? appointmentTime;
  int? patientID;
  int? doctorID;
  EnAppointmentStatus? appointmentStatus;

  ClsAppointmentDto({
    this.appointmentID,
    this.appointmentTime,
    this.patientID,
    this.doctorID,
    this.appointmentStatus,
  });

  factory ClsAppointmentDto.fromJson(Map<String, dynamic> json) {
    return ClsAppointmentDto(
      appointmentID: json['AppointmentID'] as int?,
      appointmentTime:
          json['AppointmentTime'] != null
              ? DateTime.parse(json['AppointmentTime'] as String)
              : null,
      patientID: json['PatientID'] as int?,
      doctorID: json['DoctorID'] as int?,
      appointmentStatus: EnAppointmentStatus.fromValue(
        json['AppointmentStatus'] as int?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AppointmentID': appointmentID,
      'AppointmentTime': appointmentTime?.toIso8601String(),
      'PatientID': patientID,
      'DoctorID': doctorID,
      'AppointmentStatus': appointmentStatus?.value,
    };
  }
}
