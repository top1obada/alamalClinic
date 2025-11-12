enum EnUserRole {
  eReceptionist(1),
  eDoctor(2),
  ePatient(3);

  final int value;

  const EnUserRole(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnUserRole? fromValue(int? value) {
    if (value == null) return null;
    return EnUserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnUserRole value: $value'),
    );
  }
}

class ClsUserDto {
  int? userID;
  int? personID;
  String? userName;
  List<int>? hashedPassword;
  List<int>? salt;
  DateTime? joiningDate;
  EnUserRole? userRole;

  ClsUserDto({
    this.userID,
    this.personID,
    this.userName,
    this.hashedPassword,
    this.salt,
    this.joiningDate,
    this.userRole,
  });

  factory ClsUserDto.fromJson(Map<String, dynamic> json) {
    return ClsUserDto(
      userID: json['UserID'] as int?,
      personID: json['PersonID'] as int?,
      userName: json['UserName'] as String?,
      hashedPassword:
          json['HashedPassword'] != null
              ? List<int>.from(json['HashedPassword'] as List)
              : null,
      salt: json['Salt'] != null ? List<int>.from(json['Salt'] as List) : null,
      joiningDate:
          json['JoiningDate'] != null
              ? DateTime.parse(json['JoiningDate'] as String)
              : null,
      userRole: EnUserRole.fromValue(json['UserRole'] as int?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'PersonID': personID,
      'UserName': userName,
      'HashedPassword': hashedPassword,
      'Salt': salt,
      'JoiningDate': joiningDate?.toIso8601String(),
      'UserRole': userRole?.value,
    };
  }
}
