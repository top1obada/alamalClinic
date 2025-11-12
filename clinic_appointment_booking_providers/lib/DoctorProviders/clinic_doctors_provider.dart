import 'package:clinic_appointment_booking_api_connect/Connections/DoctorConnect/doctor_connect.dart';
import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:flutter/widgets.dart';

class PVClinicDoctors extends ChangeNotifier {
  List<ClsClinicDoctorDto>? clinicDoctors;

  void clearDoctors() {
    _isLoaded = _isLoading = false;
    _isFinished = false;
    _currentPage = 1;
    clinicDoctors = null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool _isFinished = false;
  bool get isFinished => _isFinished;

  int _currentPage = 1;

  Future<void> getClinicDoctors({int pageSize = 6, String? specialty}) async {
    Errors.errorMessage = null;

    if (_isLoading || _isFinished) return;

    _isLoading = true;
    notifyListeners();

    final result = await DoctorConnect.getAllDoctors(pageSize, _currentPage);

    _isLoading = false;

    result.fold(
      (left) {
        Errors.errorMessage = left;
        notifyListeners();
        return;
      },
      (right) {
        if (right.isEmpty || right.length < pageSize) {
          if (clinicDoctors != null) {
            clinicDoctors!.addAll(right);
          } else {
            clinicDoctors = right;
          }
          _isFinished = true;
        } else {
          clinicDoctors = [...clinicDoctors ?? [], ...right];
          _currentPage++;
          _isLoaded = true;
        }
        notifyListeners();
        return;
      },
    );
  }

  // Method to filter doctors by specialty
  List<ClsClinicDoctorDto>? getDoctorsBySpecialty(String? specialty) {
    if (clinicDoctors == null) return null;

    if (specialty == null || specialty == 'الكل') {
      return clinicDoctors;
    }

    return clinicDoctors!
        .where((doctor) => doctor.specialtiesName == specialty)
        .toList();
  }
}
