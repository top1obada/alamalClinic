class ClsClinicDoctorDto {
  int? doctorID;
  String? doctorName;
  String? specialtiesName;
  String? doctorImageLink;
  String? gender;

  ClsClinicDoctorDto({
    this.doctorID,
    this.doctorName,
    this.specialtiesName,
    this.doctorImageLink,
    this.gender,
  });

  factory ClsClinicDoctorDto.fromJson(Map<String, dynamic> json) {
    return ClsClinicDoctorDto(
      doctorID: json['DoctorID'] as int?,
      doctorName: json['DoctorName'],
      specialtiesName: json['SpecialtiesName'],
      doctorImageLink: json['DoctorImageLink'],
      gender: json['Gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DoctorID': doctorID,
      'DoctorName': doctorName,
      'SpecialtiesName': specialtiesName,
      'DoctorImageLink': doctorImageLink,
      'Gender': gender,
    };
  }
}
