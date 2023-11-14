import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/Failure.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/model/comment_model.dart';

import '../../../core/provider/firebase_provider.dart';
import '../../../model/community_model.dart';
import '../../../model/post_model.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: ref.watch(
      firestoreProvider,
    ),
  ),
);

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(
        FirebaseConstants.postsCollection,
      );
  CollectionReference get _comments => _firestore.collection(
        FirebaseConstants.commentsCollection,
      );
  CollectionReference get _users => _firestore.collection(
        FirebaseConstants.usersCollection,
      );

  //! Add post
  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! Fetch post by community name
  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  //! Delete post
  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! Up vote
  void upVote(Post post, String userId) {
    //! Down vote is there first remove it
    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }
    //! If up vote is already there then remove it
    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      //! Else update the up vote
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  //! Down vote
  void downVote(Post post, String userId) {
    //! If up vote is there first remove it
    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }
    //! If down vote is already there then remove it
    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      //! Else update the down vote
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  //! Get post by id
  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  //! save comments
  FutureVoid saveComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! Get post comments
  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  //! Give awards to post
  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      await _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! Fetch guest posts
  Stream<List<Post>> fetchGuestPosts() {
    return _posts
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
