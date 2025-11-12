import 'dart:convert';
import 'package:clinic_appointment_booking_dto/UserDTO/retriving_logged_in_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/user_dto.dart';

class ClsJWTTokenHelper {
  ClsJWTTokenHelper._();

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);

    return json.decode(payloadString);
  }

  static ClsRetrivingLoggedInDTO? extractLoginInfoFromToken(String? token) {
    if (token == null) return null;

    Map<String, dynamic> payload = _parseJwt(token);

    int? personId;
    if (payload.containsKey('PersonID') && payload['PersonID'] != null) {
      personId = int.tryParse(payload['PersonID'].toString());
    }

    int? userId;
    if (payload.containsKey('UserID') && payload['UserID'] != null) {
      userId = int.tryParse(payload['UserID'].toString());
    }

    int? userBranchID;
    if (payload.containsKey('UserBranchID') &&
        payload['UserBranchID'] != null) {
      userBranchID = int.tryParse(payload['UserBranchID'].toString());
    }

    EnUserRole? userRole;
    if (payload.containsKey(
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
        ) &&
        payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] !=
            null) {
      userRole = EnUserRole.values.firstWhere(
        (v) =>
            v.name ==
            payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
                .toString(),
      );
    }

    DateTime? parseCustomDate(String dateString) {
      try {
        // تنسيق yyyy/MM/dd
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    // Parse JoiningDate
    DateTime? joiningDate;
    if (payload.containsKey('JoiningDate') && payload['JoiningDate'] != null) {
      final dateString = payload['JoiningDate'].toString();
      joiningDate = parseCustomDate(dateString);
    }

    return ClsRetrivingLoggedInDTO.fromJson({
      'FirstName':
          payload.containsKey('FirstName') ? payload['FirstName'] : null,
      'PersonID': personId,
      'UserID': userId,
      'UserBranchID': userBranchID,
      'JoiningDate': joiningDate,
      'UserRole': userRole?.value,
    });
  }
}
