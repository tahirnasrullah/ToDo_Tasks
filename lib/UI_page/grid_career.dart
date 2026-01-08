import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'elements/contanier_gradient.dart';
import 'elements/image_ui.dart';
import 'elements/text_ui.dart';

class GridViewCareer extends StatefulWidget {
  final List<Map<String, String>> careerList;

  const GridViewCareer(this.careerList, {super.key});

  @override
  State<GridViewCareer> createState() => _GridViewCareerState();
}

class _GridViewCareerState extends State<GridViewCareer> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,

      children: widget.careerList.mapIndexed((index, value) {
        final bool isSelected = selectedIndex == index;
        return InkWell(
          child: SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  image_ui_gridview(value, 'image'),
                  ?isSelected ? contanier_gradient() : null,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ?isSelected ? text_ui_shadow(value, 'job') : null,
                              ?isSelected ? text_ui_shadow(value, 'company') : null,
                            ],
                          ),
                        ),
                        ?isSelected ? text_ui_shadow(value, 'experience') : null,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            setState(() {
              selectedIndex = isSelected ? null : index;
            });
          },
        );
      }).toList(),
    );
  }
}
