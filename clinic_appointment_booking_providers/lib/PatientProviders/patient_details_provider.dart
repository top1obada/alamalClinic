import 'package:clinic_appointment_booking_api_connect/Connections/PatientConnect/patient_connect.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_details_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVPatientDetails extends ChangeNotifier {
  ClsPatientDetailsDto? _patientDetails;
  bool _isLoading = false;
  bool _isLoaded = false;

  ClsPatientDetailsDto? get patientDetails => _patientDetails;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  void clearPatientDetails() {
    _patientDetails = null;
    _isLoaded = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getPatientDetails(int patientID) async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await PatientConnect.getPatientDetails(patientID);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        _patientDetails = right;
        _isLoaded = true;
        notifyListeners();
        return;
      },
    );
  }
}
