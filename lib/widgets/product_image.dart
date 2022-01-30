import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key, this.url}) : super(key: key);
  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var boxDecoration = BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      color: Colors.black,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 10,
          offset: const Offset(0, 0),
        ),
      ],
    );
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      decoration: boxDecoration,
      width: size.width,
      height: size.height * 0.5,
      child: Opacity(
        opacity: 0.9,
        child: getImage(url),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }

  Widget getImage(String? picture) {
    if (picture == null) {
      return const FadeInImage(
        placeholder: AssetImage('assets/images/jar-loading.gif'),
        image: NetworkImage('https://res.cloudinary.com/brandon-rs/image/upload/v1643560194/no-image_suebjt.jpg'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/images/jar-loading.gif'),
        image: NetworkImage(url ?? 'https://res.cloudinary.com/brandon-rs/image/upload/v1643560194/no-image_suebjt.jpg'),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
