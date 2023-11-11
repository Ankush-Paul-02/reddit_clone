import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: currentTheme.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 16,
          child: Icon(
            Icons.image_outlined,
            size: iconSize,
            color: currentTheme.iconTheme.color,
          ).centered(),
        ).box.size(cardHeightWidth, cardHeightWidth).make().onTap(
              () => navigateToType(context, 'image'),
            ),
        Card(
          color: currentTheme.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 16,
          child: Icon(
            Icons.font_download_outlined,
            size: iconSize,
            color: currentTheme.iconTheme.color,
          ).centered(),
        ).box.size(cardHeightWidth, cardHeightWidth).make().onTap(
              () => navigateToType(context, 'text'),
            ),
        Card(
          color: currentTheme.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 16,
          child: Icon(
            Icons.link_outlined,
            size: iconSize,
            color: currentTheme.iconTheme.color,
          ).centered(),
        ).box.size(cardHeightWidth, cardHeightWidth).make().onTap(
              () => navigateToType(context, 'link'),
            ),
      ],
    ).p12();
  }
}
