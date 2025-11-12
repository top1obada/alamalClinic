import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';
import 'package:clinic_appointment_booking_api_connect/Connections/AppointmentConnect/apponitment_connect.dart';

class PVCreateAppointment extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccess = false;
  int? _createdAppointmentID;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  int? get createdAppointmentID => _createdAppointmentID;
  String? get errorMessage => _errorMessage;

  void clearState() {
    _isLoading = false;
    _isSuccess = false;
    _createdAppointmentID = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> createAppointment(ClsAppointmentDto appointmentDTO) async {
    Errors.errorMessage = null;
    _errorMessage = null;
    _isSuccess = false;
    _createdAppointmentID = null;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    final result = await AppointmentConnect.createAppointment(appointmentDTO);

    _isLoading = false;

    return result.fold(
      (left) {
        _errorMessage = left;
        Errors.errorMessage = left;
        notifyListeners();
        return false;
      },
      (right) {
        _createdAppointmentID = right;
        _isSuccess = true;
        notifyListeners();
        return true;
      },
    );
  }
}
