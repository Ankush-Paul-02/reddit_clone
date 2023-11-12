import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controllers/post_controller.dart';
import 'package:reddit_clone/model/community_model.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            file: bannerFile,
            selectedCommunity: selectedCommunity ?? communities[0],
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            link: linkController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );
    } else {
      showSnackBar(context, 'Please enter all the fields!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: 'Post ${widget.type}'.text.make(),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: sharePost,
            child: 'Share'.text.color(Colors.blue).make(),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Enter title here',
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
            maxLength: 30,
          ),
          20.heightBox,
          if (isTypeImage)
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
                    : const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                      ),
              ),
            ).onTap(
              () => selectBannerImage(),
            ),
          if (isTypeText)
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter description here',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
              maxLines: 5,
            ),
          if (isTypeLink)
            TextField(
              controller: linkController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter link here',
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
          20.heightBox,
          Align(
            alignment: Alignment.topLeft,
            child: 'Select Community'.text.size(16).make(),
          ),
          ref.watch(userCommunityProvider).when(
                data: (community) {
                  communities = community;
                  if (community.isEmpty) {
                    return const SizedBox();
                  }
                  return DropdownButton(
                    value: selectedCommunity ?? community[0],
                    items: community
                        .map(
                          (currentCommunity) => DropdownMenuItem(
                            value: currentCommunity,
                            child: Text(currentCommunity.name),
                          ),
                        )
                        .toList(),
                    onChanged: (newCommunity) {
                      setState(() {
                        selectedCommunity = newCommunity;
                      });
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ).p8(),
    );
  }
}
