import 'package:clinic_appointment_booking_dto/UserDTO/user_dto.dart';

class ClsRetrivingLoggedInDTO {
  int? personID;
  int? userID;
  int? userBranchID;
  String? firstName;
  DateTime? joiningDate;
  EnUserRole? userRole;

  ClsRetrivingLoggedInDTO({
    this.personID,
    this.userID,
    this.userBranchID,
    this.firstName,
    this.joiningDate,
    this.userRole,
  });

  factory ClsRetrivingLoggedInDTO.fromJson(Map<String, dynamic> json) {
    return ClsRetrivingLoggedInDTO(
      personID: json['PersonID'] as int?,
      userID: json['UserID'] as int?,
      userBranchID: json['UserBranchID'] as int?,
      firstName: json['FirstName'] as String?,
      joiningDate:
          json['JoiningDate'] != null
              ? (json['JoiningDate'] as DateTime)
              : null,
      userRole: EnUserRole.fromValue(json['UserRole'] as int?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PersonID': personID,
      'UserID': userID,
      'UserBranchID': userBranchID,
      'FirstName': firstName,
      'JoiningDate': joiningDate?.toIso8601String(),
      'UserRole': userRole?.value,
    };
  }
}
