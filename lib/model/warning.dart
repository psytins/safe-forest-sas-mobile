import 'package:intl/intl.dart';

class Warning {
  final String cameraId;
  final DateTime date; // Change type to DateTime
  final int sensitivity;
  final String imageUrl;

  Warning({
    required this.cameraId,
    required this.date,
    required this.sensitivity,
    required this.imageUrl,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    // Parse date string into DateTime object
    DateTime parsedDate = DateTime.parse(json['date']);

    return Warning(
      cameraId: json['camera']['camera_name'], // Convert to String
      date: parsedDate,
      sensitivity: json['camera']['sensitivity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cameraId': cameraId,
      'date': date.toIso8601String(), // Convert DateTime back to ISO 8601 string if needed
      'sensitivity': sensitivity,
      'imageUrl': imageUrl,
    };
  }
}
