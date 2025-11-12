import 'package:clinic_appointment_booking_dto/DoctorDTO/doctor_details.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/available_appointment_times_provider.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/booking_appointment_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_ui/AppointmentUI/booking_appointment_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/doctor_details_provider.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorID;

  const DoctorDetailsScreen({super.key, required this.doctorID});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PVDoctorDetails>().getDoctorDetails(widget.doctorID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفاصيل الطبيب',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<PVDoctorDetails>(
                builder: (context, doctorDetailsProvider, child) {
                  if (doctorDetailsProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  }

                  if (!doctorDetailsProvider.isLoaded ||
                      doctorDetailsProvider.doctorDetails == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد بيانات',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final doctor = doctorDetailsProvider.doctorDetails!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildProfileCard(doctor),
                        const SizedBox(height: 20),
                        _buildSpecializationCard(doctor),
                        const SizedBox(height: 20),
                        _buildConsultationCard(doctor),
                        const SizedBox(height: 20),
                        _buildWorkTimeCard(doctor),
                        const SizedBox(height: 20),
                        _buildHolidaysCard(doctor),
                        const SizedBox(height: 20),
                        _buildPersonalInfoCard(doctor),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildAppointmentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _bookAppointment();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'حجز موعد',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  void _bookAppointment() {
    final doctor = context.read<PVDoctorDetails>().doctorDetails;
    if (doctor == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (inner) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (c) => PVAvailableAppointmentTimes(),
                ),
                ChangeNotifierProvider(create: (c) => PVCreateAppointment()),
                // Reuse the existing providers from parent context
                ChangeNotifierProvider.value(
                  value: context.read<PVBaseCurrentLoginInfo>(),
                ),
              ],
              child: AppointmentBookingScreen(doctorID: widget.doctorID),
            ),
      ),
    );
  }

  Widget _buildProfileCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                doctor.doctorImageLink != null
                    ? NetworkImage(doctor.doctorImageLink!)
                    : null,
            child:
                doctor.doctorImageLink == null
                    ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                    : null,
          ),
          const SizedBox(height: 16),
          Text(
            _getDoctorNameWithTitle(doctor),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            doctor.specialtiesName ?? 'تخصص غير محدد',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'التخصص',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.medical_services, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            doctor.specialtiesName ?? 'غير محدد',
            style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          if (doctor.specialtiesDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              doctor.specialtiesDescription!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConsultationCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'معلومات الاستشارة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.access_time, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                [
                  _buildInfoItem(
                    'رسوم الاستشارة',
                    '${doctor.consultationFee?.toStringAsFixed(2) ?? '0'} ل.س',
                    Icons.attach_money,
                  ),
                  _buildInfoItem(
                    'مدة الاستشارة',
                    '${doctor.consultationDurationInMinutes ?? 0} دقيقة',
                    Icons.timer,
                  ),
                ].reversed.toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkTimeCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'أوقات العمل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.schedule, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                [
                  _buildInfoItem(
                    'وقت الانتهاء',
                    doctor.endTime ?? 'غير محدد',
                    Icons.timer_off,
                  ),
                  _buildInfoItem(
                    'وقت البدء',
                    doctor.startTime ?? 'غير محدد',
                    Icons.timer,
                  ),
                ].reversed.toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaysCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'أيام الإجازة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.event_busy, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 12),
          if (doctor.holidays != null && doctor.holidays!.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children:
                  doctor.holidays!
                      .map(
                        (day) => Chip(
                          label: Text(
                            day,
                            style: const TextStyle(fontSize: 12),
                            textDirection: TextDirection.rtl,
                          ),
                          backgroundColor: Colors.blue[50],
                          side: BorderSide(color: Colors.blue[100]!),
                        ),
                      )
                      .toList(),
            )
          else
            Text(
              'لا توجد أيام إجازة',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(ClsDoctorDetailsDto doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'المعلومات الشخصية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.person_outline, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 16),
          _buildPersonalInfoRow('الجنس', _getGenderText(doctor.gender)),
          const SizedBox(height: 12),
          _buildPersonalInfoRow('الجنسية', doctor.nationality ?? 'غير محدد'),
          if (doctor.birthDate != null) ...[
            const SizedBox(height: 12),
            _buildPersonalInfoRow(
              'تاريخ الميلاد',
              _formatDate(doctor.birthDate!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[600], size: 28),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textDirection: TextDirection.rtl,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
          ].reversed.toList(),
    );
  }

  String _getDoctorNameWithTitle(ClsDoctorDetailsDto doctor) {
    String title = '';

    if (doctor.gender == 'M') {
      title = 'الدكتور ';
    } else if (doctor.gender == 'F') {
      title = 'الدكتورة ';
    }

    String doctorName = doctor.doctorName ?? 'غير معروف';

    if (doctorName.startsWith('د. ') ||
        doctorName.startsWith('الدكتور ') ||
        doctorName.startsWith('الدكتورة ')) {
      return doctorName;
    }

    return title + doctorName;
  }

  String _getGenderText(String? gender) {
    if (gender == 'M') return 'ذكر';
    if (gender == 'F') return 'أنثى';
    return 'غير محدد';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
