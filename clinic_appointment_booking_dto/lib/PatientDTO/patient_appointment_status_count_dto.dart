class ClsPatientAppointmentStatusCountDto {
  int? pendingAppointments;
  int? confirmedAppointments;
  int? rejectedAppointments;
  int? cancelledAppointments;
  int? completedAppointments;

  ClsPatientAppointmentStatusCountDto({
    this.pendingAppointments,
    this.confirmedAppointments,
    this.rejectedAppointments,
    this.cancelledAppointments,
    this.completedAppointments,
  });

  factory ClsPatientAppointmentStatusCountDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClsPatientAppointmentStatusCountDto(
      pendingAppointments: json['PendingAppointments'],
      confirmedAppointments: json['ConfirmedAppointments'],
      rejectedAppointments: json['RejectedAppointments'],
      cancelledAppointments: json['CancelledAppointments'],
      completedAppointments: json['CompletedAppointments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PendingAppointments': pendingAppointments,
      'ConfirmedAppointments': confirmedAppointments,
      'RejectedAppointments': rejectedAppointments,
      'CancelledAppointments': cancelledAppointments,
      'CompletedAppointments': completedAppointments,
    };
  }
}
