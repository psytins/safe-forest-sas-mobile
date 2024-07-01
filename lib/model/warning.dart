import 'package:intl/intl.dart';

class Warning {
  final String cameraId;
  final DateTime date;
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
    DateTime parsedDate = DateTime.parse(json['date']).toLocal();

    return Warning(
      cameraId: json['camera']['camera_name'],
      date: parsedDate,
      sensitivity: json['camera']['sensitivity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cameraId': cameraId,
      'date': date.toIso8601String(),
      'sensitivity': sensitivity,
      'imageUrl': imageUrl,
    };
  }
}
