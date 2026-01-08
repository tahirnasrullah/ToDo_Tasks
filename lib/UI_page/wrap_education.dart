import 'package:flutter/cupertino.dart';
import 'elements/image_ui.dart';
import 'elements/text_ui.dart';

class wrap_education extends StatelessWidget {
  final List<Map<String, String>> education_list;

  const wrap_education(this.education_list, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: education_list
          .map(
            (value) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 150,
                  child: Stack(
                    children: [
                      image_ui_wrap(value, 'image'),
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
    );
  }
}
