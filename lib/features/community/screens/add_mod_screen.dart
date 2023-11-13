import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uIds = {};
  int counter = 0;

  void addUId(String uid) {
    setState(() {
      uIds.add(uid);
    });
  }

  void removeUId(String uid) {
    setState(() {
      uIds.remove(uid);
    });
  }

  void saveMods(WidgetRef ref, BuildContext context) {
    ref.read(communityControllerProvider.notifier).addMods(
          widget.name,
          uIds.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => saveMods(ref, context),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && counter == 0) {
                          uIds.add(member);
                        }
                        counter++;
                        return CheckboxListTile(
                          value: uIds.contains(user.uid),
                          onChanged: (value) {
                            if (value!) {
                              addUId(user.uid);
                            } else {
                              removeUId(user.uid);
                            }
                          },
                          title: user.name.text.make(),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
