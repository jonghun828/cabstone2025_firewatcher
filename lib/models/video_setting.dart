// lib/models/video_setting.dart

/// 저장되는 영상의 화질을 정의하는 Enum.
enum VideoQuality {
  low,    // 저화질
  medium, // 중화질
  high,   // 고화질
}

/// 영상 설정 정보를 담는 데이터 모델.
class VideoSetting {
  int detectionRecordingMinutes; // 감지 시점 전후로 저장되는 영상의 길이 (분 단위)
  VideoQuality selectedVideoQuality; // 선택된 영상 화질

  /// VideoSetting 생성자.
  ///
  /// [detectionRecordingMinutes] 감지 시점 전후로 저장될 영상의 분 단위.
  ///   예: 5분 -> 감지 전 5분 + 감지 후 5분 = 총 10분 영상.
  ///   최소 1분, 최대 15분으로 가정합니다.
  VideoSetting({
    this.detectionRecordingMinutes = 5, // 기본값: 감지 전후 5분 (총 10분)
    this.selectedVideoQuality = VideoQuality.medium, // 기본값: 중화질
  });

  /// VideoSetting 객체의 특정 필드를 변경하여 새로운 인스턴스를 생성하는 메서드.
  VideoSetting copyWith({
    int? detectionRecordingMinutes,
    VideoQuality? selectedVideoQuality,
  }) {
    return VideoSetting(
      detectionRecordingMinutes: detectionRecordingMinutes ?? this.detectionRecordingMinutes,
      selectedVideoQuality: selectedVideoQuality ?? this.selectedVideoQuality,
    );
  }
}