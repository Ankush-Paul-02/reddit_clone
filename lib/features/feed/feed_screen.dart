import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controllers/post_controller.dart';
import 'package:reddit_clone/responsive/responsive.dart';

import '../auth/controllers/auth_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return !isGuest
        ? ref.watch(userCommunityProvider).when(
              data: (community) => ref.watch(userPostsProvider(community)).when(
                    data: (posts) => ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            )
        : ref.watch(userCommunityProvider).when(
              data: (community) => ref.watch(guestPostsProvider).when(
                    data: (posts) => ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
  }
}
