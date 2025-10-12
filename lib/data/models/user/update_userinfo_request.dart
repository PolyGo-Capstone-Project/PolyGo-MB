class UpdateInfoRequest {
  final String name;
  final String introduction;
  final String avatarUrl;
  final String gender;

  UpdateInfoRequest({
    required this.name,
    required this.introduction,
    required this.avatarUrl,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'introduction': introduction,
      'avatarUrl': avatarUrl,
      'gender': gender,
    };
  }
}
