class MeResponse {
  final String id;
  final String name;
  final String mail;
  final String? avatarUrl;
  final int meritLevel;
  final int gender;
  final int experiencePoints;
  final String role;

  MeResponse({
    required this.id,
    required this.name,
    required this.mail,
    this.avatarUrl,
    required this.meritLevel,
    required this.gender,
    required this.experiencePoints,
    required this.role,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      mail: json['mail'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      meritLevel: json['meritLevel'] as int,
      gender: json['gender'] as int,
      experiencePoints: json['experiencePoints'] as int,
      role: json['role'] as String,
    );
  }
}
