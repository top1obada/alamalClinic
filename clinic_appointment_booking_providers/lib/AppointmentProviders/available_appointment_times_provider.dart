import 'package:clinic_appointment_booking_api_connect/Connections/AppointmentConnect/apponitment_connect.dart';

import 'package:clinic_appointment_booking_dto/AppointmentDTO/available_appointment_times_dto.dart';

import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVAvailableAppointmentTimes extends ChangeNotifier {
  List<ClsAvailableAppointmentTimeDto>? availableTimes;
  bool _isLoading = false;
  bool _isLoaded = false;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  void clearTimes() {
    availableTimes = null;
    _isLoaded = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAvailableAppointmentTimes(
    ClsAvailableTimeAppointmentsFilterDto filterDto,
  ) async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await AppointmentConnect.getAvailableAppointmentTimes(
      filterDto,
    );

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        availableTimes = right;
        _isLoaded = true;
        notifyListeners();
        return;
      },
    );
  }
}
