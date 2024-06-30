class Warning {
  final String cameraId;
  final String date;
  final int sensitivity;
  final String imageUrl;

  Warning({
    required this.cameraId,
    required this.date,
    required this.sensitivity,
    required this.imageUrl,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      cameraId: json['camera_id'].toString(), // Convert to String
      date: json['date'] ?? '',
      sensitivity: json['camera']['sensitivity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cameraId': cameraId,
      'date': date,
      'sensitivity': sensitivity,
      'imageUrl': imageUrl,
    };
  }
}
