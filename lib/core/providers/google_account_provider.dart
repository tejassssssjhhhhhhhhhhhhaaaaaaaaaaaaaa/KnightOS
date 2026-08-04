import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_auth_service.dart';

final googleAccountProvider = StreamProvider<GoogleSignInAccount?>((ref) {
  return GoogleAuthService.instance.onCurrentUserChanged;
});
