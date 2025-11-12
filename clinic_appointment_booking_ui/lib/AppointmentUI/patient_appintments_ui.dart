import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_dto.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/patient_appointments_by_status_provider.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/patient_appointments_provider.dart';
import 'package:clinic_appointment_booking_ui/TemplatesUI/cards_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_widgets/AppintmentWidgets/patient_appointment_widget.dart';

class PatientAppointmentsUi extends StatefulWidget {
  final EnAppointmentStatus? filterStatus;

  const PatientAppointmentsUi({super.key, this.filterStatus});

  @override
  State<PatientAppointmentsUi> createState() {
    return _PatientAppointmentsUi();
  }
}

class _PatientAppointmentsUi extends State<PatientAppointmentsUi> {
  final ScrollController _scrollController = ScrollController();

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadAppointments();
        }
      });

      await _loadAppointments();
    });
  }

  Future<void> _loadAppointments() async {
    final patientID =
        context
            .read<PVBaseCurrentLoginInfo>()
            .retrivingLoggedInDTO!
            .userBranchID!;

    if (widget.filterStatus != null) {
      await context
          .read<PVPatientAppointmentsByStatus>()
          .getPatientAppointmentsByStatus(
            patientID,
            widget.filterStatus!,
            pageSize: 10,
          );
    } else {
      await context.read<PVPatientAppointments>().getPatientAppointments(
        patientID,
        pageSize: 10,
      );
    }
  }

  @override
  Widget build(BuildContext baseContext) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: _onBackPressed,
          ),
          title: Text(
            widget.filterStatus != null
                ? 'مواعيدي - ${_getStatusText(widget.filterStatus)}'
                : 'جميع مواعيدي',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:
                        widget.filterStatus != null
                            ? _buildWithStatusProvider()
                            : _buildWithDefaultProvider(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithStatusProvider() {
    return Consumer<PVPatientAppointmentsByStatus>(
      builder: (context, appointmentsProvider, child) {
        return _buildCardsTemplate(appointmentsProvider);
      },
    );
  }

  Widget _buildWithDefaultProvider() {
    return Consumer<PVPatientAppointments>(
      builder: (context, appointmentsProvider, child) {
        return _buildCardsTemplate(appointmentsProvider);
      },
    );
  }

  Widget _buildCardsTemplate(dynamic provider) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CardsTemplate(
        scrollController: _scrollController,
        isLoaded: provider.isLoaded,
        isFinished: provider.isFinished,
        values: provider.patientAppointments,
        lineLength: 1,
        widgetGetter: GetPatientAppointmentWidget(),
        onCardClick: (appointment) {
          final patientAppointment = appointment as ClsPatientAppointmentDto;
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: Text(
                Errors.errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAppointments,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: Text(
              'جاري تحميل المواعيد...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: Text(
                _getEmptyStateSubtitle(widget.filterStatus),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyStateMessage(EnAppointmentStatus status) {
    switch (status) {
      case EnAppointmentStatus.ePending:
        return 'لا توجد مواعيد في الانتظار';
      case EnAppointmentStatus.eConfirmed:
        return 'لا توجد مواعيد مؤكدة';
      case EnAppointmentStatus.eRejected:
        return 'لا توجد مواعيد مرفوضة';
      case EnAppointmentStatus.eCancelled:
        return 'لا توجد مواعيد ملغية';
      case EnAppointmentStatus.eCompleted:
        return 'لا توجد مواعيد مكتملة';
      default:
        return 'لا توجد مواعيد';
    }
  }

  String _getEmptyStateSubtitle(EnAppointmentStatus? status) {
    switch (status) {
      case EnAppointmentStatus.ePending:
        return 'سيظهر هنا المواعيد التي تنتظر التأكيد';
      case EnAppointmentStatus.eConfirmed:
        return 'سيظهر هنا المواعيد المؤكدة القادمة';
      case EnAppointmentStatus.eRejected:
        return 'سيظهر هنا المواعيد التي تم رفضها';
      case EnAppointmentStatus.eCancelled:
        return 'سيظهر هنا المواعيد التي تم إلغاؤها';
      case EnAppointmentStatus.eCompleted:
        return 'سيظهر هنا المواعيد التي تم إكمالها';
      default:
        return 'سيظهر هنا جميع مواعيدك عند حجزها';
    }
  }

  String _getStatusText(EnAppointmentStatus? status) {
    switch (status) {
      case EnAppointmentStatus.ePending:
        return 'في الانتظار';
      case EnAppointmentStatus.eConfirmed:
        return 'مؤكدة';
      case EnAppointmentStatus.eRejected:
        return 'مرفوضة';
      case EnAppointmentStatus.eCancelled:
        return 'ملغية';
      case EnAppointmentStatus.eCompleted:
        return 'مكتملة';
      default:
        return '';
    }
  }
}
