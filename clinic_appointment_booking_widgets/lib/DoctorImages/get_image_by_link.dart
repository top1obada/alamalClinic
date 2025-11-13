import 'package:clinic_appointment_booking_widgets/Loaders/hope_loader.dart';
import 'package:flutter/material.dart';

class CloudinaryImage extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  final double? imageWidth;
  final BoxFit? fit;

  const CloudinaryImage({
    Key? key,
    required this.imageUrl,
    required this.imageHeight,
    this.imageWidth,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.person,
            color: Colors.grey[400],
            size: imageHeight * 0.5,
          ),
        );
      },
    );
  }
}
