import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_widgets/DoctorImages/get_image_by_link.dart';
import 'package:clinic_appointment_booking_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDDoctorCard extends StatefulWidget {
  const WDDoctorCard({super.key, required this.doctorDTO, this.onCardClicked});

  final ClsClinicDoctorDto doctorDTO;
  final Function(ClsClinicDoctorDto?)? onCardClicked;

  @override
  State<WDDoctorCard> createState() => _WDDoctorCardState();
}

class _WDDoctorCardState extends State<WDDoctorCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Colors.blue[50]!;

  String _getDoctorTitle() {
    final gender = widget.doctorDTO.gender ?? '';
    return gender == 'F' ? 'الدكتورة' : 'الدكتور';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isLargeDevice = screenWidth > 600;

    return Padding(
      padding: EdgeInsets.all(4),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onCardClicked?.call(widget.doctorDTO);
          setState(() => _isPressed = false);
        },
        child: Card(
          color: _isPressed ? _pressedColor : _normalColor,
          elevation: _isPressed ? 3 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isPressed ? Colors.blue[300]! : Colors.grey[300]!,
              width: _isPressed ? 1.5 : 1,
            ),
          ),
          margin: const EdgeInsets.all(6),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Doctor Profile Image - Square shape for profile
                _buildDoctorProfileImage(isSmallDevice, isLargeDevice),

                const SizedBox(height: 8),

                // Doctor Name - Centered with proper title
                Text(
                  '${_getDoctorTitle()} ${widget.doctorDTO.doctorName ?? 'غير معروف'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallDevice ? 16 : 20,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                const SizedBox(height: 4),

                // Specialties - Centered
                Text(
                  widget.doctorDTO.specialtiesName ?? 'تخصص غير معروف',
                  style: TextStyle(
                    fontSize: isSmallDevice ? 12 : 14,
                    color: Colors.blue[700],
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfileImage(bool isSmallDevice, bool isLargeDevice) {
    // Suitable profile image sizes
    final imageSize = isSmallDevice ? 70.0 : (isLargeDevice ? 100.0 : 85.0);

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Circular shape for profile
        color: Colors.grey[100],
        border: Border.all(color: Colors.blue[100]!, width: 2.0),
      ),
      child: ClipOval(
        child:
            widget.doctorDTO.doctorImageLink != null &&
                    widget.doctorDTO.doctorImageLink!.isNotEmpty
                ? CloudinaryImage(
                  imageUrl: widget.doctorDTO.doctorImageLink!,
                  imageHeight: imageSize,
                  imageWidth: imageSize,
                  fit: BoxFit.cover,
                )
                : _buildProfilePlaceholderIcon(imageSize),
      ),
    );
  }

  Widget _buildProfilePlaceholderIcon(double size) {
    return Center(
      child: Icon(
        Icons.person,
        color: Colors.grey[400],
        size: size * 0.6, // Slightly larger icon for better visibility
      ),
    );
  }
}

class GetClinicDoctorWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDDoctorCard(
      doctorDTO: value as ClsClinicDoctorDto,
      onCardClicked: onClick,
    );
  }
}
