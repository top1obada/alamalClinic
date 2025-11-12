import 'package:clinic_appointment_booking_api_connect/Connections/PersonConnect/person_connect.dart';
import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVGetPersonInfo extends ChangeNotifier {
  ClsPersonDto? _personDetails;
  bool _isLoading = false;
  bool _isLoaded = false;

  ClsPersonDto? get personDetails => _personDetails;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  void clearPersonDetails() {
    _personDetails = null;
    _isLoaded = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getPerson(int personID) async {
    Errors.errorMessage = null;

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final result = await PersonConnect.getPerson(personID);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        _personDetails = right;
        _isLoaded = true;
        notifyListeners();
        return;
      },
    );
  }
}
