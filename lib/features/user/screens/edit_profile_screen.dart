import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/user/controller/user_profile_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/palette.dart';

class EditUserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends ConsumerState<EditUserProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: 'Edit Profile'.text.make(),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(),
                  child: 'Save'.text.color(Colors.blue).make(),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Column(
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
                              color: currentTheme.textTheme.bodyMedium!.color!,
                              child: Container(
                                width: 100.w,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : user.banner.isEmpty ||
                                            user.banner ==
                                                Constants.bannerDefault
                                        ? const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          )
                                        : Image.network(
                                            user.banner,
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
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePic),
                                      radius: 32,
                                    ).onTap(() => selectProfileImage()),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                    ],
                  ).p(8),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
