/// 개별 알림음 옵션.
class Ringtone {
  final String id;    // 알림음 ID
  final String name;  // 알림음 이름

  const Ringtone({
    required this.id,
    required this.name,
  });

  // RadioListTile에서 비교를 위해 필요한 equals 및 hashCode 재정의
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ringtone &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 개별 진동 패턴 옵션.
class VibrationPattern {
  final String id;    // 진동 패턴 ID
  final String name;  // 진동 패턴 이름

  const VibrationPattern({
    required this.id,
    required this.name,
  });

  // RadioListTile에서 비교를 위해 필요한 equals 및 hashCode 재정의
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VibrationPattern &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 알림 설정 정보를 담는 데이터 모델.
class NotificationSetting {
  bool enableSound;   // 소리 알림 활성화 여부
  bool enableVibration; // 진동 알림 활성화 여부
  Ringtone selectedRingtone;    // 선택된 알림음 (null 아님)
  VibrationPattern selectedVibrationPattern; // 선택된 진동 패턴 (null 아님)

  /// NotificationSetting 생성자.
  NotificationSetting({
    required this.enableSound,
    required this.enableVibration,
    required this.selectedRingtone,
    required this.selectedVibrationPattern,
  });

  /// NotificationSetting 객체의 특정 필드를 변경하여 새로운 인스턴스를 생성하는 메서드.
  NotificationSetting copyWith({
    bool? enableSound,
    bool? enableVibration,
    Ringtone? selectedRingtone,
    VibrationPattern? selectedVibrationPattern,
  }) {
    return NotificationSetting(
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
      selectedRingtone: selectedRingtone ?? this.selectedRingtone,
      selectedVibrationPattern: selectedVibrationPattern ?? this.selectedVibrationPattern,
    );
  }
}