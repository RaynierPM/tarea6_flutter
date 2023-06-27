import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar getAppBar(String title) => AppBar(
  title: Text(title),
);


class Screen {
  Screen(this.context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  BuildContext context;

  double width = 0;
  double height = 0;
}

Future<void> navigate(String path) async {
  if (!await launchUrl(Uri.parse(path))) throw Exception("No se pudo lanzar");
}




final List<List<String>> rutas = [
  ["Adivino tu genero", "/genero"],
  ["Adivino tu edad", "/edad"],
  ["Universidades", "/universidad"],
  ["El clima en RD", '/clima'],
  ["Periodico HOY", "/periodico"],
  ["Contratame", "/contratame"]
];
