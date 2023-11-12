import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/model/community_model.dart';
import 'package:reddit_clone/model/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/provider/storage_repository_provider.dart';
import '../../../core/utils.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  //! share text post
  void shareTextPost({
    required BuildContext context,
    required String title,
    required String description,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider);

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user!.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final newPost = await _postRepository.addPost(post);
    state = false;

    newPost.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  //! share link post
  void shareLinkPost({
    required BuildContext context,
    required String title,
    required String link,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider);

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user!.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final newPost = await _postRepository.addPost(post);
    state = false;

    newPost.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  //! share image post
  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    });
  }
}
