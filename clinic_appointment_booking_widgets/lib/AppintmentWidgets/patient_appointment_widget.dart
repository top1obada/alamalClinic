import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_dto.dart';
import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDPatientAppointmentCard extends StatefulWidget {
  const WDPatientAppointmentCard({
    super.key,
    required this.patientAppointmentDTO,
    this.onCardClicked,
  });

  final ClsPatientAppointmentDto patientAppointmentDTO;
  final Function(ClsPatientAppointmentDto?)? onCardClicked;

  @override
  State<WDPatientAppointmentCard> createState() =>
      _WDPatientAppointmentCardState();
}

class _WDPatientAppointmentCardState extends State<WDPatientAppointmentCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Color(0xFFE3F2FD);
  final Color _shadowColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            widget.onCardClicked?.call(widget.patientAppointmentDTO);
            setState(() => _isPressed = false);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
            child: Card(
              elevation: _isPressed ? 6 : 4,
              shadowColor: _shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: _isPressed ? Colors.blueAccent : Colors.grey[300]!,
                  width: _isPressed ? 2.0 : 1.2,
                ),
              ),
              color: _isPressed ? _pressedColor : _normalColor,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 12),
                    _buildDoctorInfo(),
                    const SizedBox(height: 12),
                    _buildTimeSection(),
                    const SizedBox(height: 12),
                    _buildStatusIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final Color statusColor = _getStatusColor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor, width: 1.5),
          ),
          child: Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        Expanded(
          child: Text(
            'موعد #${widget.patientAppointmentDTO.doctorID ?? 'N/A'}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
              fontFamily: 'Tajawal',
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الطبيب',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.patientAppointmentDTO.doctorFullName ?? 'طبيب غير معروف',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Tajawal',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.patientAppointmentDTO.specialtiesName ?? 'تخصص غير معروف',
          style: TextStyle(
            fontSize: 14,
            color: Colors.green[700],
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.blue),
            const SizedBox(width: 6),
            Text(
              'الموعد: ${_formatDateTime(widget.patientAppointmentDTO.appointmentTime)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
            const SizedBox(width: 6),
            Text(
              'التاريخ: ${_formatDate(widget.patientAppointmentDTO.appointmentTime)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'حالة الموعد',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: _getProgressValue(),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${(_getProgressValue() * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--/--/----';
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  Color _getStatusColor() {
    switch (widget.patientAppointmentDTO.appointmentStatus) {
      case EnAppointmentStatus.ePending:
        return Colors.orange;
      case EnAppointmentStatus.eCancelled:
        return Colors.red;
      case EnAppointmentStatus.eRejected:
        return Colors.red[900]!;
      case EnAppointmentStatus.eConfirmed:
        return Colors.blue;
      case EnAppointmentStatus.eCompleted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (widget.patientAppointmentDTO.appointmentStatus) {
      case EnAppointmentStatus.ePending:
        return 'قيد الانتظار';
      case EnAppointmentStatus.eCancelled:
        return 'ملغي';
      case EnAppointmentStatus.eRejected:
        return 'مرفوض';
      case EnAppointmentStatus.eConfirmed:
        return 'مؤكد';
      case EnAppointmentStatus.eCompleted:
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }

  double _getProgressValue() {
    switch (widget.patientAppointmentDTO.appointmentStatus) {
      case EnAppointmentStatus.ePending:
        return 0.3;
      case EnAppointmentStatus.eCancelled:
        return 0.0;
      case EnAppointmentStatus.eRejected:
        return 0.0;
      case EnAppointmentStatus.eConfirmed:
        return 0.7;
      case EnAppointmentStatus.eCompleted:
        return 1.0;
      default:
        return 0.0;
    }
  }
}

class GetPatientAppointmentWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDPatientAppointmentCard(
      patientAppointmentDTO: value as ClsPatientAppointmentDto,
      onCardClicked: onClick,
    );
  }
}
