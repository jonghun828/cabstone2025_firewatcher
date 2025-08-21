# cabstone2025_firewatcher

종합설계

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter SDK 설치
운영체제에 맞는 Flutter SDK 압축 파일 다운로드(Stable)
https://flutter.dev/docs/get-started/install
C드라이브에 압축 해제
환경 변수 설정
시스템 환경 변수 편집 검색 -> 환경 변수 클릭
시스템 변수 목록에서 Path를 찾아서 편집 클릭 
새로 만들기 클릭 -> Flutter SDK 폴더 안의 bin 폴더 경로(예: C:\flutter\bin)를 추가 -> 확인

# Git 설치
운영체제에 맞는 버전 다운로드
https://git-scm.com/downloads

# Android Studio 설치
운영체제에 맞는 Android Studio 다운로드
https://developer.android.com/studio
아래로 스크롤
실행 -> File -> Settings -> Plugins -> Marketplace Flutter 검색 설치 -> Dart도 함께 설치 -> 재시작
File -> Settings -> Languages & Frameworks -> SDK tools -> Android SDK Build, Command-line, Platform-Tools 체크 -> Apply
File -> Settings -> Languages & Frameworks -> Flutter -> Flutte SDK path 설정 -> 압축해제한 flutter 파일 선택 -> Apply
Dart SDK path는 자동으로 선택

- Android 라이선스 동의
flutter doctor --android-licenses (y를 입력)
- 최종확인
flutter doctor