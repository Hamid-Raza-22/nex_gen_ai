/// Authenticated user profile returned by the backend.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.tokens = 0,
    this.words = 0,
    this.avatarUrl,
    this.emailVerifiedAt,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final num tokens;
  final num words;
  final String? avatarUrl;
  final DateTime? emailVerifiedAt;

  num get credits => tokens; // Alias for dashboard

  bool get isEmailVerified => emailVerifiedAt != null;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      tokens: (json['num_of_tokens'] ?? json['tokens'] ?? 0) as num,
      words: (json['num_of_words'] ?? json['words'] ?? 0) as num,
      avatarUrl: json['avatar'] as String? ?? json['profile_photo_url'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'] as String)
          : null,
    );
  }
}
