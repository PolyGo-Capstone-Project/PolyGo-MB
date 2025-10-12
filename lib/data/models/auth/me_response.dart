class MeResponse {
  final String id;
  final String name;
  final String mail;
  final String? avatarUrl;
  final String meritLevel;
  final String introduction;
  final String gender;
  final int experiencePoints;
  final String role;

  MeResponse({
    required this.id,
    required this.name,
    required this.mail,
    this.avatarUrl,
    required this.meritLevel,
    required this.introduction,
    required this.gender,
    required this.experiencePoints,
    required this.role,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mail: json['mail']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      meritLevel: json['meritLevel']?.toString() ?? '',
      introduction: json['introduction']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      experiencePoints: (json['experiencePoints'] is int)
          ? json['experiencePoints'] as int
          : int.tryParse(json['experiencePoints']?.toString() ?? '0') ?? 0,
      role: json['role']?.toString() ?? '',
    );
  }

}
