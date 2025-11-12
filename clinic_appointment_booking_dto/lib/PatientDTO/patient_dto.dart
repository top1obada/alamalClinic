class ClsPatientDto {
  int? patientID;
  int? userID;

  ClsPatientDto({this.patientID, this.userID});

  factory ClsPatientDto.fromJson(Map<String, dynamic> json) {
    return ClsPatientDto(patientID: json['PatientID'], userID: json['UserID']);
  }

  Map<String, dynamic> toJson() {
    return {'PatientID': patientID, 'UserID': userID};
  }
}
