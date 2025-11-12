class ClsPersonDto {
  int? personID;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? birthDate;
  String? gender;
  String? nationality;

  ClsPersonDto({
    this.personID,
    this.firstName,
    this.middleName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.nationality,
  });

  factory ClsPersonDto.fromJson(Map<String, dynamic> json) {
    return ClsPersonDto(
      personID: json['PersonID'] as int?,
      firstName: json['FirstName'] as String?,
      middleName: json['MiddleName'] as String?,
      lastName: json['LastName'] as String?,
      birthDate:
          json['BirthDate'] != null
              ? DateTime.parse(json['BirthDate'] as String)
              : null,
      gender: json['Gender'] as String?,
      nationality: json['Nationality'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PersonID': personID,
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'BirthDate': birthDate?.toIso8601String(),
      'Gender': gender,
      'Nationality': nationality,
    };
  }
}
