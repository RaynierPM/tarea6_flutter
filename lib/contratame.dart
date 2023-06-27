import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';

class Contratame extends StatelessWidget {
  const Contratame({super.key});

  final TextStyle texto = const TextStyle(
    fontFamily: "Diphy",
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Contratame"),

    backgroundColor: const Color.fromARGB(129, 162, 205, 176),

    body: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.white, blurRadius: 7,spreadRadius: 10,blurStyle: BlurStyle.normal, offset: Offset(3, 5))
                ]
              ),
              child: Image.asset("assets/ray.png", width: 400, height: 400, fit: BoxFit.fitHeight,),
            ),
            Expanded(child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Raynier Perez Minyety", style: texto,),
                Text("20210218@itla.edu.do", style: texto,),
                Text("raynierminyety@gmail.com", style: texto,),
                Text("github.com/RaynierPM", style: texto,),
                Text("Telefono: 849-402-8297", style: texto,)
                ],
              ) 
            )
        ],
      ),
    )
  );
}