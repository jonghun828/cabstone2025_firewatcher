// lib/models/language.dart

/// 앱에서 지원하는 언어를 정의하는 Enum.
enum LanguageCode { // <--- AppLanguageCode -> LanguageCode
  ko, // 한국어
  en, // 영어
  zh, // 중국어 (간체)
  ja, // 일본어
}

/// LanguageCode Enum에 대한 확장 함수.
/// 언어 코드를 사용자 친화적인 이름으로 변환합니다.
extension LanguageName on LanguageCode { // <--- AppLanguageName -> LanguageName
  String get displayName {
    switch (this) {
      case LanguageCode.ko: return '한국어';
      case LanguageCode.en: return 'English';
      case LanguageCode.zh: return '中文';
      case LanguageCode.ja: return '日本語';
    }
  }
}

/// 앱의 언어 설정을 담는 데이터 모델.
class LanguageSetting { // <--- AppLanguageSetting -> LanguageSetting
  LanguageCode selectedLanguage; // 선택된 언어 코드

  /// LanguageSetting 생성자.
  LanguageSetting({
    this.selectedLanguage = LanguageCode.ko, // 기본값: 한국어
  });

  /// LanguageSetting 객체의 특정 필드를 변경하여 새로운 인스턴스를 생성하는 메서드.
  LanguageSetting copyWith({
    LanguageCode? selectedLanguage,
  }) {
    return LanguageSetting(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}