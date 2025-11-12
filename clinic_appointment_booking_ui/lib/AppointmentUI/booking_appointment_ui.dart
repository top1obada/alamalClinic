import 'package:clinic_appointment_booking_dto/AppointmentDTO/available_appointment_times_dto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clinic_appointment_booking_dto/AppointmentDTO/appointment_dto.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/available_appointment_times_provider.dart';
import 'package:clinic_appointment_booking_providers/AppointmentProviders/booking_appointment_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:project_widgets/TimeWidgets/time_selector_widget.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final int doctorID;

  const AppointmentBookingScreen({super.key, required this.doctorID});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isDateSelected = false;

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
          'حجز موعد',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDateSelectorCard(),
                    const SizedBox(height: 20),
                    if (_isDateSelected) _buildTimeSelectionCard(),
                  ],
                ),
              ),
            ),
            if (_selectedTime != null) _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectorCard() {
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
                'اختر التاريخ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today, color: Colors.blue[700], size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  [
                    IconButton(
                      icon: Icon(Icons.calendar_month, color: Colors.blue[700]),
                      onPressed: _selectDate,
                    ),
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                          : 'اختر التاريخ',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            _selectedDate != null
                                ? Colors.blueGrey
                                : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ].reversed.toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionCard() {
    return Consumer<PVAvailableAppointmentTimes>(
      builder: (context, availableTimesProvider, child) {
        if (availableTimesProvider.isLoading) {
          return Container(
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
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!availableTimesProvider.isLoaded ||
            availableTimesProvider.availableTimes == null) {
          return Container(
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
            child: const Center(
              child: Text(
                'لا توجد أوقات متاحة',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        final availableTimes =
            availableTimesProvider.availableTimes!
                .map((timeDto) => timeDto.availableTime?.substring(0, 5) ?? '')
                .where((time) => time.isNotEmpty)
                .toList();

        return TimeSelectionWidget(
          times: availableTimes,
          title: 'المواعيد المتاحة',
          onTimeSelected: (selectedTime) {
            setState(() {
              _selectedTime = selectedTime;
            });
          },
        );
      },
    );
  }

  Widget _buildBookButton() {
    return Consumer<PVCreateAppointment>(
      builder: (context, createAppointmentProvider, child) {
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
          child:
              createAppointmentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _createAppointment,
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
                      'تأكيد الحجز',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _isDateSelected = true;
        _selectedTime = null;
      });

      final filterDto = ClsAvailableTimeAppointmentsFilterDto(
        date: _selectedDate,
        doctorID: widget.doctorID,
      );

      await context
          .read<PVAvailableAppointmentTimes>()
          .getAvailableAppointmentTimes(filterDto);
    }
  }

  void _createAppointment() {
    if (_selectedDate == null || _selectedTime == null) return;

    final appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(_selectedTime!.split(':')[0]),
      int.parse(_selectedTime!.split(':')[1]),
    );

    final appointmentDto = ClsAppointmentDto(
      doctorID: widget.doctorID,
      patientID:
          context
              .read<PVBaseCurrentLoginInfo>()
              .retrivingLoggedInDTO!
              .userBranchID,
      appointmentTime: appointmentDateTime,
      appointmentStatus: EnAppointmentStatus.ePending,
    );

    context.read<PVCreateAppointment>().createAppointment(appointmentDto).then((
      success,
    ) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تم حجز الموعد بنجاح',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<PVCreateAppointment>().errorMessage ??
                  'فشل حجز الموعد',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
