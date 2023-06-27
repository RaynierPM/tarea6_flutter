import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EdadPage extends StatelessWidget {
  const EdadPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Adivino tu edad"),
    body: Container(
      width: Screen(context).width,
      height: Screen(context).height,
      padding: const EdgeInsets.all(5.0),
      child: const EdadForm(),
    ),
  );
}


class EdadForm extends StatefulWidget {
  const EdadForm({super.key});

  @override
  State<EdadForm> createState() => _EdadFormState();
}


class _EdadFormState extends State<EdadForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _controller = TextEditingController(); 

  int? edad;
  String? nombre;
  bool mostrar = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Ingrese un nombre",
              hintText: "Ej: Patricia"
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Inserte un nombre";
              }

              return null;
            },
          )
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15.0),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              getEdad(_controller.text);
            }
          }, 
          child: SizedBox(
            width: Screen(context).width,
            child: const Text("Adivinar", textAlign: TextAlign.center),
          )
        ),

        if (mostrar) 
        SizedBox(
          height: Screen(context).height * .2,
          child: Center(child: getDelimitacionEdad(),)
        )
        
      ]
    );
  }

  Future<void> getEdad(String name) async {
    final response = await http.get(Uri.parse("https://api.agify.io/?name=$name"));
    nombre = name;
    int? edadFutura;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      edadFutura = data["age"];
      error = false;
    }else {
      edadFutura = null;
      error = true;
    } 



    mostrar = true;
    setState(() => edad = edadFutura);
    
  }


  Widget getDelimitacionEdad() {
    String resultado;
    if (edad == null || edad !< 0) {
      resultado = "La edad no pudo ser especificada, lo sentimos.";
    }else if (edad !< 12) {
      resultado = "La edad de $nombre es de: $edad. Es un niño.";
    }else if (edad !< 30) {
      resultado = "La edad de $nombre es de: $edad. Es un joven. ${edad !> 18? "(Legalmente adulto)": null}";
    }else if (edad !< 60) {
      resultado = "La edad de $nombre es de: $edad. Es un adulto.";
    }else {
      resultado = "La edad de $nombre es de: $edad. Es una persona mayor (Anciano/a).";
    }

    return 
    Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(resultado,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          decorationStyle: TextDecorationStyle.dashed
        ),
      )
    );
  }


}