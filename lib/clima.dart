import 'package:flutter/material.dart';
import 'package:tarea6_flutter/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClimaPage extends StatelessWidget {
  ClimaPage({super.key});

  final fecha = DateTime.now();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: getAppBar("Clima RD - Hora: ${fecha.hour}:${fecha.minute}"),
    body: const ClimaDetails(),
  );
}


class ClimaDetails extends StatefulWidget {
  const ClimaDetails({super.key});

  @override
  State<ClimaDetails> createState() => _ClimaDetailsState();
}

class _ClimaDetailsState extends State<ClimaDetails> {
  
  String? pais;
  
  bool error = false;
  bool cargando = true;
  Clima? actualClima; 
  

  List<List<String>>? seccionPrecip;



  @override
  void initState() {
    super.initState();
    getClima();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10.0),
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
            "Error, no pudimos cargar la sección del clima",
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            actualClima!.getWeatherStatus(context),
            Container(
              padding: const EdgeInsets.all(5.0),
              width: Screen(context).width * .5,
              height: Screen(context).width * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  generateLabels("Temperatura: ", "${actualClima!.temperature}°"),
                  generateLabels("Sensación térmica: ", "${actualClima!.temperatureApparent}°"),
                  generateLabels("Indice de rayos UV: ", actualClima!.getUvIndexText())
                ],
              )
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color.fromARGB(255, 74, 113, 101)
          ),
          width: MediaQuery.of(context).size.width,
          child: const Center(child: Text("Precipitaciones", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, fontFamily: 'Diphy', color: Colors.white),)),
        ),
        SizedBox(
          height: Screen(context).height * .2,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceAround,
            spacing: 20.0,
            children: seccionPrecip!.map((label) => 
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5)
                ),
                width: Screen(context).width * .44,
                height: 50,
                margin: const EdgeInsets.only(top: 15.0),

                child: Center(child: generateLabels(label[0], label[1])),
              )
            ).toList(),
          )
        ),
        Center(child: Text("Clima de $pais", style: TextStyle(color: Colors.grey),),)
      ]
    ),
  );

  Future<void> getClima() async {
    final response = await http.get(Uri.parse('https://api.tomorrow.io/v4/weather/realtime?location=Dominican+republic&apikey=GB6jE6qMgfLeESMgCX66ULzn8rN7Ltik'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body)["data"]["values"];

      setState(() {
        actualClima = Clima.fromJson(jsonData);
        if (actualClima != null) cargando = false;

        seccionPrecip = [
          ["% de humedad: ", "${actualClima!.humedadPercent}%"],
          ["proba. de lluvia: ", "${actualClima!.precipitacionPercent}%"],
          ["Vel. del viento: ", "${actualClima!.windSpeed} m/s"],
        ];

        if (actualClima!.rainIntensity > 0) seccionPrecip!.add(["Fuerza de la lluvia: ", "${actualClima!.rainIntensity} mm/hr"]);

        pais = json.decode(response.body)["location"]["name"];

      });
    }else {
      setState(() {
        cargando = false;
        error = true;
      });
    }
  
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




class Clima {
  Clima(
    this.humedadPercent, 
    this.precipitacionPercent, 
    this.temperature,
    this.temperatureApparent, 
    this.uvIdex, 
    this.windSpeed,
    this.weatherCode, 
    this.rainIntensity
  );

  final int humedadPercent; // %
  final int precipitacionPercent; // % 
  final double temperature; // Grados
  final double temperatureApparent;
  final int uvIdex; // 0-2 bajo, "3-5: Moderate 6-7: High 8-10: Very High 11+: Extreme"
  final double windSpeed; // Metros por segundo
  final int weatherCode; // Codigo int
  final double rainIntensity;

  DateTime fecha = DateTime.now();

  String getUvIndexText() {
    String response;

    switch (uvIdex) {
      case >= 0 && <= 2:
        response = "bajo";
        break;
      case > 2 && <= 5:
        response = "Moderado";
        break;
      case > 6 && <= 7:
        response = "Alto";
        break;
      case > 7 && <= 10:
        response = "Muy alto";
        break;
      case > 11:
        response = "Extremo";
        break;
      default:
        response = "Error";
    }
    return response;
  }

final Map<String, List<dynamic>> weatherCodes = {
  "0": ["Desconocido", Colors.black, Colors.grey],
  "1000": ["Despejado", Colors.white, Colors.blue],
  "1100": ["Mayormente despejado", Colors.black, Colors.orange],
  "1101": ["Parcialmente nublado", Colors.black, Colors.yellow],
  "1102": ["Mayormente nublado", Colors.black, Colors.grey],
  "1001": ["Nublado", Colors.white, Colors.grey],
  "2000": ["Niebla", Colors.black, Colors.lightBlue],
  "2100": ["Niebla ligera", Colors.black, Colors.lightBlueAccent],
  "4000": ["Llovizna", Colors.black, Colors.lightBlue],
  "4001": ["Lluvia", Colors.white, Colors.blue],
  "4200": ["Lluvia ligera", Colors.white, Colors.blue],
  "4201": ["Lluvia intensa", Colors.white, Colors.blue],
  "5000": ["Nieve", Colors.black, Colors.white],
  "5001": ["Chubascos de nieve", Colors.black, Colors.white],
  "5100": ["Nieve ligera", Colors.black, Colors.white],
  "5101": ["Nieve intensa", Colors.black, Colors.white],
  "6000": ["Llovizna helada", Colors.white, Colors.lightBlue],
  "6001": ["Lluvia helada", Colors.white, Colors.blue],
  "6200": ["Lluvia helada ligera", Colors.white, Colors.blue],
  "6201": ["Lluvia helada intensa", Colors.white, Colors.blue],
  "7000": ["Granizo", Colors.white, Colors.grey],
  "7101": ["Granizo intenso", Colors.white, Colors.grey],
  "7102": ["Granizo ligero", Colors.white, Colors.grey],
  "8000": ["Tormenta eléctrica", Colors.white, Colors.deepPurple],
};


  factory Clima.fromJson(Map<String, dynamic> json) => Clima(
    int.parse(json["humidity"].toString()), 
    int.parse(json["precipitationProbability"].toString()), 
    double.parse(json["temperature"].toString()), 
    double.parse(json["temperatureApparent"].toString()), 
    json["uvIndex"], 
    double.parse(json["windSpeed"].toString()),
    int.parse(json["weatherCode"].toString()),
    double.parse(json["rainIntensity"].toString())
  );


  Widget getWeatherStatus(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(width: 1.0),
      borderRadius: BorderRadius.circular(15.0),
      color: weatherCodes[weatherCode.toString()]![2]
    ),
    padding: const EdgeInsets.all(10.0),
    width: Screen(context).width * .4,
    height: Screen(context).width * .4,
    child: Center(
      child: Text("Clima: ${weatherCodes[weatherCode.toString()]![0]}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: weatherCodes[weatherCode.toString()]![1]
        ),
      ),
    ),
  );
}