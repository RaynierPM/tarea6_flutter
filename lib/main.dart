import 'package:flutter/material.dart';
import 'package:tarea6_flutter/contratame.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:tarea6_flutter/genero.dart';
import 'package:tarea6_flutter/edad.dart';
import 'package:tarea6_flutter/universidad.dart';
import 'package:tarea6_flutter/clima.dart';
import 'package:tarea6_flutter/periodico.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Tarea6_Couteau",
    color: const Color.fromARGB(255, 133, 163, 137),
    theme: ThemeData(
      colorScheme: const ColorScheme.light(onPrimary: Colors.white, primary: Color.fromARGB(255, 74, 113, 101)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15.0),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        )
      )
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/' : (context) => const MainPage(),
      '/genero':(context) => const GeneroPage(),
      '/edad' : (context) => const EdadPage(),
      '/universidad': (context) => const UniPage(),
      '/clima': (context) => ClimaPage(),
      '/periodico':(context) => const PeriodicoPage(),
      '/contratame': (context) => const Contratame()
    }
  ); 
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Toolbox :D"),
    body: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/caja_herramientas.jpg", width: MediaQuery.of(context).size.width * .9),
          Expanded(
            child: ListView(
              children: menuGenerator(rutas, context),
            )
          )
        ],
      ),
    )
  );

  List<Widget> menuGenerator(List<List<String>> rutas, BuildContext context) {
    List<Widget> botonesXFila = [];
    List<Widget> filas = [];
    for(int i = 0; i < rutas.length; i++) {
      
      botonesXFila.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            Screen(context).width * .45, 
            75
          )
        ),
        onPressed: () => Navigator.pushNamed(context, rutas[i][1]), 
        child: Text(rutas[i][0])
      ));

      if ((i % 2 != 0) || i == rutas.length-1) {
        filas.add(Container(
          padding: const EdgeInsets.all(5.0), 
          width: MediaQuery.of(context).size.width,
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: botonesXFila
            )
          )
        );
        botonesXFila = [];
      }

    }
    return filas;
  }
}