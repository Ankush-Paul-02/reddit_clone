import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../features/auth/controllers/auth_controller.dart';

class SigninButton extends ConsumerWidget {
  final bool isFromLogin;
  const SigninButton({
    super.key,
    this.isFromLogin = true,
  });

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(ref, context),
      icon: Image.asset(
        Constants.googlePath,
        width: 35,
      ),
      label: 'Continue With Google'.text.size(18).white.make(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.greyColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ).p(18);
  }
}
