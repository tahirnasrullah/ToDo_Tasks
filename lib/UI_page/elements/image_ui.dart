



import 'package:flutter/cupertino.dart';

Widget image_ui_listview(value,image_key){
  return Image.network(
    value[image_key]!,
    height: 100,
    width: 100,
    fit: BoxFit.cover,
  );
}


Widget image_ui_wrap(value,image_key){
  return Image.network(
    value[image_key]!,
    height: 80,
    width: 150,
    fit: BoxFit.cover,
  );
}



Widget image_ui_gridview(value,image_key,){
  return Image.network(
      value[image_key]!,
    width: 400,
    height: 400,
    fit: BoxFit.cover,
  );
}


Widget image_ui_list_tile(value,image_key){
  return Image.network(
    value[image_key]!,
    height: 40,
    width: 60,
    fit: BoxFit.cover,
  );
}





