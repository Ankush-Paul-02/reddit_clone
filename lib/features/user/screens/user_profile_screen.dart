import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../auth/controllers/auth_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditProfileScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        )
                            .box
                            .padding(
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                            )
                            .alignment(Alignment.bottomLeft)
                            .make(),
                        OutlinedButton(
                          onPressed: () => navigateToEditProfileScreen(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: 'Edit Profile'.text.color(Colors.blue).make(),
                        )
                            .box
                            .padding(
                              const EdgeInsets.all(20),
                            )
                            .alignment(Alignment.bottomLeft)
                            .make(),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${user.karma} Karma',
                            ),
                          ),
                          10.heightBox,
                          const Divider(thickness: 2, color: Palette.greyColor),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: 'Display Posts'.text.make().centered(),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
