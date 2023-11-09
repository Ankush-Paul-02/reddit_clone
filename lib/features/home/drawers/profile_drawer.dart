import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            10.heightBox,
            'u/${user.name}'.text.size(16).semiBold.make(),
            10.heightBox,
            const Divider(color: Palette.greyColor),
            ListTile(
              title: 'My Profile'.text.make(),
              leading: const Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: 'Logout'.text.make(),
              leading: Icon(
                Icons.logout,
                color: Palette.redColor,
              ),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
              value: true,
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
