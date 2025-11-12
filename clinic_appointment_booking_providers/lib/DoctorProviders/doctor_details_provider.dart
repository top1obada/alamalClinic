import 'package:clinic_appointment_booking_api_connect/Connections/DoctorConnect/doctor_connect.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/doctor_details.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVDoctorDetails extends ChangeNotifier {
  ClsDoctorDetailsDto? _doctorDetails;
  bool _isLoading = false;
  bool _isLoaded = false;

  ClsDoctorDetailsDto? get doctorDetails => _doctorDetails;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  void clearDoctorDetails() {
    _doctorDetails = null;
    _isLoaded = false;
    _isLoading = false;
  }

  Future<void> getDoctorDetails(int doctorID) async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await DoctorConnect.getDoctorDetails(doctorID);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        _doctorDetails = right;
        _isLoaded = true;
        notifyListeners();
        return;
      },
    );
  }
}
