import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:velocity_x/velocity_x.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({Key? key, required this.name}) : super(key: key);

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddModScreen(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Mod Tools'.text.make().centered(),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: 'Add Moderators'.text.make(),
            onTap: () => navigateToAddModScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: 'Edit Community'.text.make(),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
