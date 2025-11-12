import 'package:clinic_appointment_booking_api_connect/Connections/DoctorConnect/doctor_connect.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVSearchDoctors extends ChangeNotifier {
  List<ClsClinicDoctorDto>? searchDoctors;

  void clearDoctors() {
    _isLoaded = _isLoading = false;
    _isFinished = false;
    _currentPage = 1;
    searchDoctors = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  int _currentPage = 1;
  String? _currentSearchTerm;

  Future<void> getClinicDoctors({int pageSize = 6, String? searchTerm}) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    if (searchTerm != _currentSearchTerm) {
      clearDoctors();
      _currentSearchTerm = searchTerm;
    }

    _isLoading = true;
    notifyListeners();

    final result = await DoctorConnect.searchDoctorsByName(
      searchTerm!,
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
          if (searchDoctors != null) {
            searchDoctors!.addAll(right);
          } else {
            searchDoctors = right;
          }
          _isFinished = true;
        } else {
          searchDoctors = [...searchDoctors ?? [], ...right];
          _currentPage++;
          _isLoaded = true;
        }
        notifyListeners();
        return;
      },
    );
  }
}
