import 'package:equatable/equatable.dart';
import 'auth_user.dart';

/// Represents the unified identity of the KnightOS user.
/// It aggregates multiple authentication providers and profile information.
class Identity extends Equatable {
  const Identity({
    required this.id,
    required this.primaryEmail,
    this.displayName,
    this.photoUrl,
    required this.authProviders,
    this.metadata = const {},
  });

  /// Internal KnightOS unique identifier.
  final String id;

  /// Primary email associated with the identity.
  final String primaryEmail;

  /// User's chosen display name.
  final String? displayName;

  /// User's profile picture URL.
  final String? photoUrl;

  /// List of authenticated providers linked to this identity.
  final List<AuthUser> authProviders;

  /// Additional metadata (e.g., account creation date, preferences).
  final Map<String, dynamic> metadata;

  /// Creates an empty identity (for guest mode or initial state).
  static const Identity empty = Identity(
    id: '',
    primaryEmail: '',
    authProviders: [],
  );

  bool get isEmpty => this == Identity.empty;

  Identity copyWith({
    String? id,
    String? primaryEmail,
    String? displayName,
    String? photoUrl,
    List<AuthUser>? authProviders,
    Map<String, dynamic>? metadata,
  }) {
    return Identity(
      id: id ?? this.id,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      authProviders: authProviders ?? this.authProviders,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        primaryEmail,
        displayName,
        photoUrl,
        authProviders,
        metadata,
      ];

  @override
  bool? get stringify => true;
}
