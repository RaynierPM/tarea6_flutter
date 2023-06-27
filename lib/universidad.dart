import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniPage extends StatelessWidget {
  const UniPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Buscador de universidades"),
    body: Container(
      width: Screen(context).width,
      height: Screen(context).height,
      padding: const EdgeInsets.all(5.0),
      child: const UniForm(),
    ),
  );
}


class UniForm extends StatefulWidget {
  const UniForm({super.key});

  @override
  State<UniForm> createState() => _UniFormState();
}


class _UniFormState extends State<UniForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _controller = TextEditingController(); 

  List<Universidad> universidades = [];
  bool error = false;
  bool mostrar = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Ingrese un pais (En ingles)",
              hintText: "Ej: Dominican Republic"
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No lo deje vacio";
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
              getColleges(_controller.text);
            }
          }, 
          child: SizedBox(
            width: Screen(context).width,
            child: const Text("Buscar", textAlign: TextAlign.center),
          )
        ),
        if (mostrar) 
        Expanded(
          child: Container(
            height: Screen(context).height * .5,
            width: Screen(context).width,
            margin: const EdgeInsets.only(top: 15.0),
            
            
            child: universidades.isEmpty || error? 
            SizedBox(
              child: Center(
                child: Text(error? "Ha ocurrido un error inesperado" : "Nombre de país no valido.", 
                  style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), 
                  textAlign: TextAlign.center,
                )
              ),
            )
            
            
            :ListView.builder(
              itemCount: universidades.length,
              itemBuilder:(context, i) => Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),

                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 194, 123),
                  borderRadius: BorderRadius.circular(10.0),
                  
                  //Color.fromARGB(255, 74, 113, 101)
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  
                  children: [
                    SizedBox(
                      width: Screen(context).width * .9,
                      child: Text(universidades[i].nombre, 
                        style: const TextStyle(
                          fontFamily: 'Diphy',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0
                        ),
                      )
                    ),
                    SizedBox(
                      width: Screen(context).width * .4,
                      child: Column(
                        children: [
                          const Text("Dominios", style: TextStyle(fontSize: 20.0, fontFamily: 'Diphy', fontWeight: FontWeight.bold),),
                          Column(
                            children: universidades[i].dominios!.map((dominio) => Container(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(dominio)
                            )).toList(),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Screen(context).width * .4,
                      child: Column(
                        children: [
                          const Text("Paginas web", style: TextStyle(fontSize: 20.0, fontFamily: 'Diphy', fontWeight: FontWeight.bold),),
                          Column(
                            children: universidades[i].paginas!.map((pagina) => TextButton(
                              onPressed: () => navigate(pagina),
                              child:const Text("Ingresar pagina",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              )
                            )).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
          ))
      ]
    );
  }

  Future<void> getColleges(String pais) async {
    
    try {
      final response = await http.get(Uri.parse("http://universities.hipolabs.com/search?country=${pais.replaceAll(RegExp(r' '), "+")}"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          universidades = data.map((universidad) => Universidad.fromJson(universidad)).toList();
          error = false;
        });      
      }
    }catch(e) {
      setState(() => error = true);
    }


    setState(() => mostrar = true);
  }


}



class Universidad {
  Universidad({required this.nombre, required this.pais, this.dominios, this.paginas});

  final String nombre;
  final String pais;

  final List<dynamic>? dominios;
  final List<dynamic>? paginas;
  


  factory Universidad.fromJson(Map<String, dynamic> json) => Universidad(
    nombre: json["name"], 
    pais: json["country"], 
    dominios: json["domains"], 
    paginas: json["web_pages"]
  ); 

}