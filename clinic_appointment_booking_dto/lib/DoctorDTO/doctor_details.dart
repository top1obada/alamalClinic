class ClsDoctorDetailsDto {
  String? doctorName;
  String? gender;
  DateTime? birthDate;
  String? nationality;
  String? specialtiesName;
  int? consultationDurationInMinutes;
  double? consultationFee;
  String? specialtiesDescription;
  String? doctorImageLink;
  String? startTime;
  String? endTime;
  List<String>? holidays;

  ClsDoctorDetailsDto({
    this.doctorName,
    this.gender,
    this.birthDate,
    this.nationality,
    this.specialtiesName,
    this.consultationDurationInMinutes,
    this.consultationFee,
    this.specialtiesDescription,
    this.doctorImageLink,
    this.startTime,
    this.endTime,
    this.holidays,
  });

  factory ClsDoctorDetailsDto.fromJson(Map<String, dynamic> json) {
    List<String>? convertHolidays(List<dynamic>? holidayDays) {
      if (holidayDays == null) return null;

      final dayNames = {
        '1': 'الأحد',
        '2': 'الإثنين',
        '3': 'الثلاثاء',
        '4': 'الأربعاء',
        '5': 'الخميس',
        '6': 'الجمعة',
        '7': 'السبت',
      };

      return holidayDays
          .map((day) => dayNames[day.toString()] ?? day.toString())
          .toList();
    }

    return ClsDoctorDetailsDto(
      doctorName: json['DoctorName'],
      gender: json['Gender'],
      birthDate:
          json['BirthDate'] != null ? DateTime.parse(json['BirthDate']) : null,
      nationality: json['Nationality'],
      specialtiesName: json['SpecialtiesName'],
      consultationDurationInMinutes: json['ConsultationDurationInMinutes'],
      consultationFee:
          json['ConsultationFee'] != null
              ? double.parse(json['ConsultationFee'].toString())
              : null,
      specialtiesDescription: json['SpecialtiesDescription'],
      doctorImageLink: json['DoctorImageLink'],
      startTime: json['StartTime'],
      endTime: json['EndTime'],
      holidays: convertHolidays(json['Holidays']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DoctorName': doctorName,
      'Gender': gender,
      'BirthDate': birthDate?.toIso8601String(),
      'Nationality': nationality,
      'SpecialtiesName': specialtiesName,
      'ConsultationDurationInMinutes': consultationDurationInMinutes,
      'ConsultationFee': consultationFee,
      'SpecialtiesDescription': specialtiesDescription,
      'DoctorImageLink': doctorImageLink,
      'StartTime': startTime,
      'EndTime': endTime,
      'Holidays': holidays,
    };
  }
}
