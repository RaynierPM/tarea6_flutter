import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeriodicoPage extends StatelessWidget {
  const PeriodicoPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Últimas noticias"),
    body: const PostsDetails(),
  );
}


class PostsDetails extends StatefulWidget {
  const PostsDetails({super.key});

  @override
  State<PostsDetails> createState() => _PostsDetailsState();
}

class _PostsDetailsState extends State<PostsDetails> {
    
  bool error = false;
  bool cargando = true;
  List<dynamic>? noticias; 
  



  @override
  void initState() {
    super.initState();
    getNoticias();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5.0),
    child: error? Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 1.0),
          color: Colors.red[400]
        ),
        width: 400,
        height: 300,
        padding: const EdgeInsets.all(15.0),

        child: const Center(
          child: Text(
            "Error, no pudimos cargar esto",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              fontStyle: FontStyle.italic
            ),
          ),
        )
      ),
    )
    : cargando? 
      const Center(
        child: CircularProgressIndicator(),
      )
    :
    Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.network("https://live.mrf.io/mstore/e8f4207/f760ea5d5951aa2290200b75d2184aea62beebab/icon.png?width=144&height=144", 
              fit: BoxFit.cover,
              ),
            ),
            Text("Guardianes de la verdad", 
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(5.0),
          height: (Screen(context).height)-300,
          
          child: ListView(
            children: noticias!.map((noticia) => Container(
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.only(top: 15),
                width: Screen(context).width,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: const Color.fromRGBO(30, 136, 229, 1), width: 1.5),
                  color: Colors.grey[200],
                ),

                child: Column(
                  
                  children: [
                    SizedBox(width: Screen(context).width,
                    child: Text(noticia["title"]["rendered"],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      noticia["excerpt"]["rendered"].length == 0?
                       "No resumen disponible":
                        removeHtmlBracesAndContent(noticia["excerpt"]["rendered"]), textAlign: TextAlign.justify,),
                    TextButton(onPressed: () => navigate(noticia["link"]), 
                      child: const Text("Ver en la página oficial", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Colors.blue
                        ),
                      )
                    )
                  ],
                ),

              )
            ).toList()
          ),
        ),
      ]
    )
  );

  Future<void> getNoticias() async {
    final response = await http.get(Uri.parse('https://hoy.com.do/wp-json/wp/v2/posts?per_page=3'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        noticias = jsonData;
        if (noticias != null) cargando = false;

      });
    }else {
      setState(() {
        cargando = false;
        error = true;
      });
    }
  }

  String removeHtmlBracesAndContent(String input) {
    RegExp htmlBracesAndContentRegExp = RegExp(r'<[^>]*>|\{[^{}]*\}|\[[^\[\]]*\]');
    return input.replaceAll(htmlBracesAndContentRegExp, '');
  }

  Widget generateLabels(String label, String value) => 
  RichText(
    text: TextSpan(
      text: label, 
      style: const TextStyle(
        fontWeight: FontWeight.bold, 
        color: Colors.black),
        children: [
          TextSpan(
            text: value, 
            style: const TextStyle(
              fontWeight: FontWeight.normal
            )
          )
        ]
      )
    );

}