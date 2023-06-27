import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeneroPage extends StatelessWidget {
  const GeneroPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Adivino tu genero"),
    body: Container(
      width: Screen(context).width,
      height: Screen(context).height,
      padding: const EdgeInsets.all(5.0),
      child: const generoForm(),
    ),
  );
}


class generoForm extends StatefulWidget {
  const generoForm({super.key});

  @override
  State<generoForm> createState() => _GeneroFormState();
}


class _GeneroFormState extends State<generoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _controller = TextEditingController(); 

  String? gender;
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
              getGender(_controller.text);
            }
          }, 
          child: SizedBox(
            width: Screen(context).width,
            child: const Text("Adivinar", textAlign: TextAlign.center),
          )
        ),

        if (mostrar) 
        
        Expanded(
          child: Container(
            height: Screen(context).height * .6,
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(15.0),
              color: gender == null? Colors.red[900]: gender=="male"? Colors.blue[100]: Colors.pink[200]
            
            ),
            child: gender == null? Center(
              child: Text(error? "Hubo un error al adivinar el genero": "Imposible de adivinar",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic
                ),
              )
            )
            
            : Center(
              child: Icon(gender == "male"? Icons.male: Icons.female,
                color: gender == "male"? Colors.blue: Colors.pink,
                size: 125.0,
              )
            )
          )
        )
      ]
    );
  }

  Future<void> getGender(String name) async {
    final response = await http.get(Uri.parse("http://api.genderize.io/?name=$name"));
    
    String? futureGender;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      futureGender = data["gender"];
      error = false;
    }else {
      futureGender = null;
      error = true;
    } 



    mostrar = true;
    setState(() => gender = futureGender);
    
  }


}