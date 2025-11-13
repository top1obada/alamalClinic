import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_appointment_status_count_dto.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/patient_appointments_by_status_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/PatientProviders/patient_details_provider.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/get_person_info_provider.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/update_person_provider.dart';
import 'package:clinic_appointment_booking_ui/AppointmentUI/patient_appintments_ui.dart';
import 'package:clinic_appointment_booking_ui/PersonUI/update_person_info_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() {
    return _ProfileUI();
  }
}

class _ProfileUI extends State<ProfileUi> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginInfo =
          context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!;
      final personId = loginInfo.personID!;
      final patientId = loginInfo.userBranchID;

      await context.read<PVGetPersonInfo>().getPerson(personId);

      if (patientId != null) {
        await context.read<PVPatientDetails>().getPatientDetails(patientId);
      }
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _onUpdatePressed() {
    final personId =
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.personID!;

    Navigator.of(context)
        .push(
          material.MaterialPageRoute(
            builder:
                (inner) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (C) => PVUpdatePerson()),
                    ChangeNotifierProvider(create: (C) => PVGetPersonInfo()),
                    ChangeNotifierProvider.value(
                      value: context.read<PVBaseCurrentLoginInfo>(),
                    ),
                  ],
                  child: UpdatePersonScreen(personID: personId),
                ),
          ),
        )
        .then((updated) {
          if (updated == true) {
            // Refresh the profile data after update
            context.read<PVGetPersonInfo>().getPerson(personId);

            material.ScaffoldMessenger.of(context).showSnackBar(
              const material.SnackBar(
                content: material.Text('تم تحديث المعلومات بنجاح'),
                backgroundColor: material.Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
  }

  void _onStatusPressed(EnAppointmentStatus status) {
    Navigator.of(context).push(
      material.MaterialPageRoute(
        builder:
            (inner) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (c) => PVPatientAppointmentsByStatus(),
                ),
                ChangeNotifierProvider.value(
                  value: context.read<PVBaseCurrentLoginInfo>(),
                ),
              ],
              child: PatientAppointmentsUi(filterStatus: status),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: material.LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [material.Color(0xFF667eea), material.Color(0xFF764ba2)],
            ),
          ),
          child: material.Scaffold(
            backgroundColor: material.Colors.transparent,
            appBar: material.AppBar(
              backgroundColor: material.Colors.transparent,
              elevation: 0,
              leading: material.IconButton(
                icon: const material.Icon(
                  material.Icons.arrow_back,
                  color: material.Colors.white,
                  size: 28,
                ),
                onPressed: _onBackPressed,
              ),
              title: const material.Text(
                'الملف الشخصي',
                style: material.TextStyle(
                  color: material.Colors.white,
                  fontWeight: material.FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: material.SafeArea(
              child: material.SingleChildScrollView(
                padding: const material.EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Personal Information Card
                    _buildPersonalInfoCard(),
                    const material.SizedBox(height: 20),

                    // Patient Statistics Card
                    _buildPatientStatsCard(),

                    const material.SizedBox(height: 20),

                    // Update Button
                    _buildUpdateButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Consumer<PVGetPersonInfo>(
      builder: (context, personProvider, child) {
        if (personProvider.personDetails == null) {
          if (personProvider.isLoading) {
            return material.Container(
              padding: const material.EdgeInsets.all(60),
              decoration: _cardDecoration(),
              child: const material.Center(
                child: material.Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    material.CircularProgressIndicator(
                      valueColor:
                          material.AlwaysStoppedAnimation<material.Color>(
                            material.Color(0xFF667eea),
                          ),
                      strokeWidth: 3,
                    ),
                    material.SizedBox(height: 20),
                    material.Text(
                      'جاري تحميل البيانات...',
                      style: material.TextStyle(
                        fontSize: 18,
                        color: material.Colors.blueGrey,
                        fontWeight: material.FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (!personProvider.isLoaded) return const material.SizedBox();
            return material.Container(
              padding: const material.EdgeInsets.all(30),
              decoration: _cardDecoration(),
              child: material.Column(
                children: [
                  material.Icon(
                    material.Icons.error_outline,
                    color: material.Colors.red,
                    size: 40,
                  ),
                  const material.SizedBox(height: 16),
                  material.Text(
                    'حدث خطأ في تحميل البيانات',
                    textAlign: TextAlign.center,
                    style: material.TextStyle(
                      color: material.Colors.red,
                      fontSize: 18,
                      fontWeight: material.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        }

        final person = personProvider.personDetails!;
        return material.Container(
          decoration: _cardDecoration(),
          child: material.Padding(
            padding: const material.EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                material.Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    material.Text(
                      '${person.firstName ?? ''} ${person.lastName ?? ''}'
                          .trim(),
                      style: const material.TextStyle(
                        fontSize: 26,
                        fontWeight: material.FontWeight.bold,
                        color: material.Color(0xFF2c3e50),
                      ),
                    ),
                    material.Icon(
                      material.Icons.person_outline,
                      color: material.Colors.blue[700],
                      size: 32,
                    ),
                  ],
                ),
                const material.SizedBox(height: 8),
                material.Text(
                  person.nationality ?? 'الجنسية غير محددة',
                  style: material.TextStyle(
                    fontSize: 18,
                    color: material.Colors.grey[600],
                    fontWeight: material.FontWeight.w500,
                  ),
                ),
                const material.Divider(
                  height: 32,
                  thickness: 1.5,
                  color: material.Colors.grey,
                ),
                _buildInfoRow('الاسم الأول', person.firstName ?? 'غير محدد'),
                const material.SizedBox(height: 20),
                _buildInfoRow('اسم الأب', person.middleName ?? 'غير محدد'),
                const material.SizedBox(height: 20),
                _buildInfoRow('الاسم الأخير', person.lastName ?? 'غير محدد'),
                const material.SizedBox(height: 20),
                _buildInfoRow('الجنس', person.gender ?? 'غير محدد'),
                const material.SizedBox(height: 20),
                _buildInfoRow('الجنسية', person.nationality ?? 'غير محدد'),
                if (person.birthDate != null) ...[
                  const material.SizedBox(height: 20),
                  _buildInfoRow(
                    'تاريخ الميلاد',
                    '${person.birthDate!.year}-${person.birthDate!.month.toString().padLeft(2, '0')}-${person.birthDate!.day.toString().padLeft(2, '0')}',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatientStatsCard() {
    return Consumer<PVPatientDetails>(
      builder: (context, patientProvider, child) {
        if (patientProvider.patientDetails == null) {
          if (patientProvider.isLoading) {
            return material.Container(
              padding: const material.EdgeInsets.all(40),
              decoration: _cardDecoration(),
              child: const material.Center(
                child: material.Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    material.CircularProgressIndicator(
                      valueColor:
                          material.AlwaysStoppedAnimation<material.Color>(
                            material.Color(0xFF667eea),
                          ),
                      strokeWidth: 3,
                    ),
                    material.SizedBox(height: 16),
                    material.Text(
                      'جاري تحميل إحصائيات المواعيد...',
                      style: material.TextStyle(
                        fontSize: 16,
                        color: material.Colors.blueGrey,
                        fontWeight: material.FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!patientProvider.isLoaded) {
            return material.Container(
              padding: const material.EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: material.Column(
                children: [
                  material.Icon(
                    material.Icons.error_outline,
                    color: material.Colors.orange,
                    size: 32,
                  ),
                  const material.SizedBox(height: 12),
                  material.Text(
                    'لا توجد بيانات للمواعيد',
                    textAlign: TextAlign.center,
                    style: material.TextStyle(
                      color: material.Colors.orange,
                      fontSize: 16,
                      fontWeight: material.FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
        }

        final stats = patientProvider.patientDetails?.appointmentStatusCount;
        final joinDate = patientProvider.patientDetails?.joiningDate;

        return material.Container(
          decoration: _cardDecoration(),
          child: material.Padding(
            padding: const material.EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                material.Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const material.Text(
                      'إحصائيات المواعيد',
                      style: material.TextStyle(
                        fontSize: 22,
                        fontWeight: material.FontWeight.bold,
                        color: material.Color(0xFF2c3e50),
                      ),
                    ),
                    material.Icon(
                      material.Icons.analytics_outlined,
                      color: material.Colors.blue[700],
                      size: 32,
                    ),
                  ],
                ),
                const material.SizedBox(height: 8),

                if (joinDate != null) ...[
                  material.Text(
                    'منضم منذ: ${joinDate.year}/${joinDate.month}/${joinDate.day}',
                    style: material.TextStyle(
                      fontSize: 16,
                      color: material.Colors.grey[600],
                      fontWeight: material.FontWeight.w500,
                    ),
                  ),
                  const material.SizedBox(height: 16),
                ],

                if (stats != null) _buildTotalStats(stats),
                const material.SizedBox(height: 24),

                material.GridView.count(
                  shrinkWrap: true,
                  physics: const material.NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildClickableStatItem(
                      'في الانتظار',
                      stats?.pendingAppointments ?? 0,
                      material.Colors.orange,
                      material.Icons.schedule,
                      EnAppointmentStatus.ePending,
                    ),
                    _buildClickableStatItem(
                      'مؤكدة',
                      stats?.confirmedAppointments ?? 0,
                      material.Colors.green,
                      material.Icons.check_circle_outline,
                      EnAppointmentStatus.eConfirmed,
                    ),
                    _buildClickableStatItem(
                      'مرفوضة',
                      stats?.rejectedAppointments ?? 0,
                      material.Colors.red,
                      material.Icons.cancel_outlined,
                      EnAppointmentStatus.eRejected,
                    ),
                    _buildClickableStatItem(
                      'ملغاة',
                      stats?.cancelledAppointments ?? 0,
                      material.Colors.grey,
                      material.Icons.block,
                      EnAppointmentStatus.eCancelled,
                    ),
                    _buildClickableStatItem(
                      'مكتملة',
                      stats?.completedAppointments ?? 0,
                      material.Colors.blue,
                      material.Icons.verified_outlined,
                      EnAppointmentStatus.eCompleted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalStats(ClsPatientAppointmentStatusCountDto stats) {
    final total =
        (stats.pendingAppointments ?? 0) +
        (stats.confirmedAppointments ?? 0) +
        (stats.rejectedAppointments ?? 0) +
        (stats.cancelledAppointments ?? 0) +
        (stats.completedAppointments ?? 0);

    return material.Container(
      padding: const material.EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const material.LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [material.Color(0xFF667eea), material.Color(0xFF764ba2)],
        ),
        borderRadius: material.BorderRadius.circular(16),
        boxShadow: [
          material.BoxShadow(
            color: material.Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const material.Offset(0, 4),
          ),
        ],
      ),
      child: material.Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTotalStatItem('إجمالي المواعيد', total, material.Colors.white),
          material.Container(
            width: 2,
            height: 40,
            color: material.Colors.white.withValues(alpha: 0.3),
          ),
          _buildTotalStatItem(
            'مكتملة',
            stats.completedAppointments ?? 0,
            material.Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStatItem(String title, int count, material.Color color) {
    return material.Column(
      children: [
        material.Text(
          count.toString(),
          style: material.TextStyle(
            fontSize: 28,
            fontWeight: material.FontWeight.bold,
            color: color,
          ),
        ),
        const material.SizedBox(height: 4),
        material.Text(
          title,
          style: material.TextStyle(
            fontSize: 14,
            color: color.withValues(alpha: 0.9),
            fontWeight: material.FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildClickableStatItem(
    String title,
    int count,
    material.Color color,
    material.IconData icon,
    EnAppointmentStatus status,
  ) {
    return material.GestureDetector(
      onTap: () => _onStatusPressed(status),
      child: material.MouseRegion(
        cursor: SystemMouseCursors.click,
        child: material.AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: material.Colors.white,
            borderRadius: material.BorderRadius.circular(16),
            boxShadow: [
              material.BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const material.Offset(0, 3),
              ),
            ],
            border: material.Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: material.Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with count badge - FIXED POSITION
              material.Stack(
                alignment: Alignment.center,
                clipBehavior:
                    Clip.none, // Important: allows badge to go outside
                children: [
                  // Main icon
                  material.Icon(
                    icon,
                    color: color,
                    size: 36, // Slightly larger icon
                  ),

                  // Count badge - positioned properly
                  material.Positioned(
                    top: -8, // Position above the icon
                    right: -4, // Position to the right of icon
                    child: material.Container(
                      padding: const material.EdgeInsets.symmetric(
                        horizontal: 8, // More horizontal padding
                        vertical: 4, // More vertical padding
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle, // Circular badge
                        boxShadow: [
                          material.BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const material.Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const material.BoxConstraints(
                        minWidth: 24, // Minimum width for circular shape
                        minHeight: 24, // Minimum height for circular shape
                      ),
                      child: material.Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: const material.TextStyle(
                          fontSize: 14, // Larger font size
                          fontWeight: material.FontWeight.bold,
                          color: material.Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const material.SizedBox(height: 12),

              // Status text - larger and more visible
              material.Padding(
                padding: const material.EdgeInsets.symmetric(horizontal: 8),
                child: material.Text(
                  title,
                  textAlign: TextAlign.center,
                  style: material.TextStyle(
                    fontSize: 14, // Larger font size
                    color: material.Colors.grey[800],
                    fontWeight: material.FontWeight.w700, // Bolder
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: material.TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return material.Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: material.BorderRadius.circular(16),
        boxShadow: [
          material.BoxShadow(
            color: material.Colors.blue[700]!.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const material.Offset(0, 6),
          ),
        ],
      ),
      child: material.ElevatedButton(
        onPressed: _onUpdatePressed,
        style: material.ElevatedButton.styleFrom(
          backgroundColor: material.Colors.blue[700],
          foregroundColor: material.Colors.white,
          padding: const material.EdgeInsets.symmetric(vertical: 20),
          shape: material.RoundedRectangleBorder(
            borderRadius: material.BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const material.Text(
          'تحديث المعلومات الشخصية',
          style: material.TextStyle(
            fontSize: 20,
            fontWeight: material.FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return material.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        material.Text(
          label,
          style: material.TextStyle(
            fontSize: 18,
            color: material.Colors.grey[700],
            fontWeight: material.FontWeight.w600,
          ),
        ),
        material.Text(
          value,
          style: const material.TextStyle(
            fontSize: 18,
            color: material.Color(0xFF2c3e50),
            fontWeight: material.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: material.Colors.white.withValues(alpha: 0.97),
      borderRadius: material.BorderRadius.circular(24),
      boxShadow: [
        material.BoxShadow(
          color: material.Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const material.Offset(0, 8),
        ),
      ],
    );
  }
}
