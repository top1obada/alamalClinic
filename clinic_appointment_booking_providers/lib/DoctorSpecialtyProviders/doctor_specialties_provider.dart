import 'package:clinic_appointment_booking_api_connect/Connections/DoctorSpecialtyConnect/doctor_specialty_connect.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVDoctorSpecialties extends ChangeNotifier {
  List<String>? doctorSpecialties;

  void clearSpecialties() {
    _isLoaded = _isLoading = false;
    doctorSpecialties = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getDoctorSpecialties() async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await DoctorSpecialtyConnect.getDoctorSpecialties();

    _isLoading = false;
    _isLoaded = true;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        doctorSpecialties = right;
        notifyListeners();
        return;
      },
    );
  }
}
