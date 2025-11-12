import 'package:clinic_appointment_booking_api_connect/Connections/DoctorConnect/doctor_connect.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVPreviousDoctorsAppointments extends ChangeNotifier {
  List<ClsClinicDoctorDto>? previousDoctors;

  void clearDoctors() {
    _isLoaded = _isLoading = false;
    _isFinished = false;
    _currentPage = 1;
    previousDoctors = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  int _currentPage = 1;
  int? _currentPatientID;

  Future<void> getPreviousDoctorsAppointments({
    int pageSize = 6,
    required int patientID,
  }) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    if (patientID != _currentPatientID) {
      clearDoctors();
      _currentPatientID = patientID;
    }

    _isLoading = true;
    notifyListeners();

    final result = await DoctorConnect.getPreviousDoctorsAppointments(
      patientID,
      pageSize,
      _currentPage,
    );

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        if (right.isEmpty || right.length < pageSize) {
          if (previousDoctors != null) {
            previousDoctors!.addAll(right);
          } else {
            previousDoctors = right;
          }
          _isFinished = true;
        } else {
          previousDoctors = [...previousDoctors ?? [], ...right];
          _currentPage++;
          _isLoaded = true;
        }
        notifyListeners();
        return;
      },
    );
  }
}
