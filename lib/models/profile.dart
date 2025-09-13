class Profile {
  final String name;        // 사용자 이름
  final String phonenumber; // 전화번호
  final String email;       // 이메일 주소
  final String? photoUrl;   // 프로필 사진 URL
  final String position;    // 직책
  final String area;        // 담당 구역

  const Profile({
    required this.name,
    required this.phonenumber,
    required this.email,
    this.photoUrl,
    required this.position,
    required this.area,
  });

  Profile copyWith({
    String? name,
    String? phonenumber,
    String? email,
    String? photoUrl,
    String? position,
    String? area,
  }) {
    return Profile(
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      position: position ?? this.position,
      area: area ?? this.area,
    );
  }
}