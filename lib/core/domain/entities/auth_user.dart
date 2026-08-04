import 'package:equatable/equatable.dart';

/// Represents a user session from an authentication provider.
class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.providerId,
  });

  /// The unique identifier from the provider.
  final String uid;

  /// The user's email address.
  final String email;

  /// The user's display name.
  final String? displayName;

  /// The user's profile photo URL.
  final String? photoUrl;

  /// The identifier of the authentication provider (e.g., 'google.com').
  final String providerId;

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, providerId];

  @override
  bool? get stringify => true;
}
