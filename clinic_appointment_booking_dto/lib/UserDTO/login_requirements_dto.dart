class ClsLoginRequirementsDto {
  String? userName;
  String? password;

  ClsLoginRequirementsDto({this.userName, this.password});

  factory ClsLoginRequirementsDto.fromJson(Map<String, dynamic> json) {
    return ClsLoginRequirementsDto(
      userName: json['UserName'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'UserName': userName, 'Password': password};
  }
}
