import 'package:clinic_appointment_booking_api_connect/Connections/AppointmentConnect/apponitment_connect.dart';
import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVPatientAppointmentsByStatus extends ChangeNotifier {
  List<ClsPatientAppointmentDto>? patientAppointments;

  void clearAppointments() {
    _isLoaded = _isLoading = false;
    _isFinished = false;
    _currentPage = 1;
    patientAppointments = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  int _currentPage = 1;
  EnAppointmentStatus? _currentStatus;

  Future<void> getPatientAppointmentsByStatus(
    int patientID,
    EnAppointmentStatus status, {
    int pageSize = 10,
  }) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    if (status != _currentStatus) {
      clearAppointments();
      _currentStatus = status;
    }

    _isLoading = true;
    notifyListeners();

    final result = await AppointmentConnect.getPatientAppointmentsByStatus(
      patientID,
      status,
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
          if (patientAppointments != null) {
            patientAppointments!.addAll(right);
          } else {
            patientAppointments = right;
          }
          _isFinished = true;
        } else {
          patientAppointments = [...patientAppointments ?? [], ...right];
          _currentPage++;
          _isLoaded = true;
        }
        notifyListeners();
        return;
      },
    );
  }
}
