import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'grid_menu_item.dart';

class GridMenu extends StatelessWidget {
  const GridMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Library",
        "color": const Color(0xFF4097DB),
        "icon": Icons.music_note,
        "path": "/library"
      },
      {
        "title": "Album",
        "color": const Color(0xFF40db9d),
        "icon": Icons.album,
        "path": "/album",
      },
      {
        "title": "Artist",
        "color": const Color(0Xffdb8340),
        "icon": Icons.person,
        "path": "/artist",
      },
      {
        "title": "Playlist",
        "color": const Color(0xFFa040db),
        "icon": Icons.playlist_play,
        "path": "/playlist",
      },
    ];

    return GridView.builder(
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return GridMenuItem(
          title: menuItems[index]["title"],
          color: menuItems[index]["color"],
          icon: menuItems[index]["icon"],
          onTap: () {
            context.push(menuItems[index]["path"]);
          },
        );
      },
    );
  }
}
