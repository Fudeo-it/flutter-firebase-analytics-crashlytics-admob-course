import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:telegram_app/exceptions/upload_failed_exception.dart';

class ProfileRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseCrashlytics firebaseCrashlytics;

  ProfileRepository({
    required this.firebaseStorage,
    required this.firebaseCrashlytics,
  });

  Future<String> uploadAvatar(File file, {required String id}) async {
    try {
      final Reference ref =
          firebaseStorage.ref('/users/$id/avatar${path.extension(file.path)}');
      await ref.putFile(file);

      return ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Fimber.e('Cannot upload avatar: $e');

      await firebaseCrashlytics.recordError(
        e,
        e.stackTrace,
        reason: 'Cannot upload avatar',
      );

      throw new UploadFailedException();
    }
  }
}
