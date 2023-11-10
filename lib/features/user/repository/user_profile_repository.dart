import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/Failure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/model/user_model.dart';

import '../../../core/constants/firebase_constants.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  //! Edit user
  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
