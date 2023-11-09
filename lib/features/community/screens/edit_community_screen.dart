import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/model/community_model.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../theme/palette.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({Key? key, required this.name}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) async {
    ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: Palette.darkModeAppTheme.colorScheme.background,
            appBar: AppBar(
              title: 'Edit Community'.text.make(),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: 'Save'.text.color(Colors.blue).make(),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      DottedBorder(
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        color: Palette
                            .darkModeAppTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                          width: 100.w,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : community.banner.isEmpty ||
                                      community.banner ==
                                          Constants.bannerDefault
                                  ? const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    )
                                  : Image.network(
                                      community.banner,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ).onTap(
                        () => selectBannerImage(),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 32,
                              ).onTap(() => selectProfileImage())
                            : const CircleAvatar(
                                backgroundImage:
                                    NetworkImage(Constants.avatarDefault),
                                radius: 32,
                              ).onTap(() => selectProfileImage()),
                      ),
                    ],
                  ),
                )
              ],
            ).p(8),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
