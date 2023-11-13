import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controllers/post_controller.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../model/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  //! Delete post
  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  //! Up vote
  void upVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  //! Down vote
  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  //! Navigate to user profile
  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  //! Navigate to community profile
  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  //! Navigate to comment screen
  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //! Community pic
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                post.communityProfilePic,
                              ),
                              radius: 16,
                            ).onInkTap(
                              () => navigateToCommunity(context),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //! Community name
                                'r/${post.communityName}'
                                    .text
                                    .size(16)
                                    .bold
                                    .make(),
                                //! Post username
                                'u/${post.username}'.text.make().onInkTap(
                                      () => navigateToUserProfile(context),
                                    ),
                              ],
                            ).pOnly(left: 8),
                            const Spacer(),
                            //! Delete icon
                            if (post.uid == user!.uid)
                              IconButton(
                                onPressed: () => deletePost(ref, context),
                                icon: Icon(
                                  Icons.delete,
                                  color: Palette.redColor,
                                ),
                              ),
                          ],
                        ),
                        //! Post title
                        post.title.text.size(19).bold.make().pOnly(top: 10),
                        5.heightBox,
                        if (isTypeImage)
                          SizedBox(
                            height: 35.h,
                            width: 100.w,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (isTypeLink)
                          Container(
                            height: 150,
                            width: 100.w,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: AnyLinkPreview(
                              link: post.link!,
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                            ),
                          ),
                        if (isTypeText)
                          post.description!.text
                              .color(Colors.grey)
                              .make()
                              .box
                              .padding(
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              )
                              .alignBottomLeft
                              .make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => upVotePost(ref),
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upVotes.contains(user.uid)
                                        ? Palette.redColor
                                        : null,
                                  ),
                                ),
                                (post.upVotes.length - post.downVotes.length ==
                                            0
                                        ? 'Vote'
                                        : '${post.upVotes.length - post.downVotes.length}')
                                    .text
                                    .size(17)
                                    .make(),
                                IconButton(
                                  onPressed: () => downVotePost(ref),
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downVotes.contains(user.uid)
                                        ? Palette.blueColor
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => navigateToComments(context),
                                  icon: const Icon(
                                    Icons.comment,
                                  ),
                                ),
                                (post.commentCount == 0
                                        ? 'Comment'
                                        : '${post.commentCount}')
                                    .text
                                    .size(17)
                                    .make(),
                              ],
                            ),
                            ref
                                .watch(getCommunityByNameProvider(
                                    post.communityName))
                                .when(
                                  data: (community) {
                                    if (community.mods.contains(user.uid)) {
                                      return IconButton(
                                        onPressed: () =>
                                            deletePost(ref, context),
                                        icon: const Icon(
                                          Icons.admin_panel_settings_sharp,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                  ),
                                  loading: () => const Loader(),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ).expand(),
            ],
          ),
        ),
        10.heightBox,
      ],
    );
  }
}
