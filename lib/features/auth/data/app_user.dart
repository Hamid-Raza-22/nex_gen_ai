/// Authenticated user profile returned by the backend.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.credits,
    this.avatarUrl,
    this.emailVerifiedAt,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final num? credits;
  final String? avatarUrl;
  final DateTime? emailVerifiedAt;

  bool get isEmailVerified => emailVerifiedAt != null;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      credits: json['credits'] as num?,
      avatarUrl: json['avatar'] as String? ?? json['profile_photo_url'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'] as String)
          : null,
    );
  }
}
