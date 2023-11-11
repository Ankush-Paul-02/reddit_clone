import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: 'Home'.text.make(),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SearchCommunityDelegate(ref),
            ),
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          })
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.colorScheme.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_outlined),
            label: '',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
