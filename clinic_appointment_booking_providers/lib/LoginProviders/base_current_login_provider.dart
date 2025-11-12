import 'package:clinic_appointment_booking_api_connect/Connections/settings/dio_client.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/retriving_logged_in_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/store_Tokens.dart';
import 'package:flutter/material.dart';

class PVBaseCurrentLoginInfo extends ChangeNotifier {
  ClsRetrivingLoggedInDTO? retrivingLoggedInDTO;

  Future<void> clear() async {
    retrivingLoggedInDTO = null;
    DioClient.clearHeaders();
    DioClient.deleteOnRequest();
    await StoreTokensService.clear();
  }
}
