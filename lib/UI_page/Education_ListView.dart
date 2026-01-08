import 'package:flutter/cupertino.dart';


import 'elements/contanier_gradient.dart';
import 'elements/image_ui.dart';
import 'elements/text_ui.dart';

class Education_ListView extends StatelessWidget {
  final List<Map<String, String>> education_list;

  const Education_ListView(this.education_list, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: education_list
            .map(
              (value) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 100,
                    child: Stack(
                      children: [
                        image_ui_listview(value, 'image'),
                        contanier_gradient(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text_ui_shadow(value, 'degree'),
                              text_ui_shadow(value, 'university'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
