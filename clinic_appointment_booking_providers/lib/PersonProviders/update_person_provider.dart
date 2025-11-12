import 'package:clinic_appointment_booking_api_connect/Connections/PersonConnect/person_connect.dart';
import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVUpdatePerson extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  void clearState() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updatePerson(ClsPersonDto personDTO) async {
    Errors.errorMessage = null;
    _errorMessage = null;
    _isSuccess = false;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    final result = await PersonConnect.updatePerson(personDTO);

    _isLoading = false;

    return result.fold(
      (left) {
        _errorMessage = left;
        Errors.errorMessage = left;
        notifyListeners();
        return false;
      },
      (right) {
        _isSuccess = true;
        notifyListeners();
        return true;
      },
    );
  }
}
