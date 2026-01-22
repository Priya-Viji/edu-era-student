class MentorEntity {
  final String id;
  final String name;
  final List<String> expertise;
  final String? photoUrl;
  final String? email;

  const MentorEntity({
    required this.id,
    required this.name,
    required this.expertise,
    this.photoUrl,
    this.email,
  });
}
