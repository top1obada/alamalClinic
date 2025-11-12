import 'package:clinic_appointment_booking_api_connect/Connections/PatientConnect/patient_connect.dart';
import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/completed_patient_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/login_requirements_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/store_Tokens.dart';

import 'package:clinic_appointment_booking_providers/StaticLibraries/jwt_token_helper.dart';

class PVPatientSignUp extends PVBaseCurrentLoginInfo {
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> signUp(
    ClsCompletedPatientDto dto,
    ClsLoginRequirementsDto loginInfo,
  ) async {
    if (_isLoading) return false;

    Errors.errorMessage = null;

    _isLoading = true;

    notifyListeners();

    final result = await PatientConnect.addPatient(dto, loginInfo);

    _isLoading = false;

    return await result.fold(
      (left) async {
        Errors.errorMessage = left;
        notifyListeners();
        return false;
      },
      (right) async {
        retrivingLoggedInDTO = ClsJWTTokenHelper.extractLoginInfoFromToken(
          right.jwtToken!,
        );

        await StoreTokensService.save(right.jwtToken!, right.refreshToken!);

        DioClient.initOnRequest();

        notifyListeners();
        return true;
      },
    );
  }
}
