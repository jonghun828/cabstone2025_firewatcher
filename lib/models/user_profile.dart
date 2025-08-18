class UserProfile {
  final String name;
  final String phonenumber;
  final String email;
  final String? photoUrl;
  final String position;
  final String area;

  UserProfile({
    required this.name,
    required this.phonenumber,
    required this.email,
    this.photoUrl,
    required this.position,
    required this.area,
  });
}