import 'package:flutter/material.dart';
import 'elements/image_ui.dart';
import 'elements/text_ui.dart';

class lisview_tile_career extends StatelessWidget {
  final List<Map<String, String>> career_list;

  const lisview_tile_career(this.career_list, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: career_list
          .map(
            (value) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.titleHeight,

                leading: image_ui_list_tile(value, "image"),
                title: text_ui_shadow(value, 'job'),
                subtitle: text_ui_tile(value, 'company'),
                trailing: text_ui_tile(value, 'experience'),
              ),
            ),
          )
          .toList(),
    );
  }
}
