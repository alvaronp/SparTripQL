import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenRouteService{
  OpenRouteService({required this.startLng,required this.startLat,required this.endLng,required this.endLat});

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf62482bacff9bce7543b48cc0360485a3b7b1';
  final String journeyMode = 'foot-walking'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    http.Response response = await http.get(Uri.parse('$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print("$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }
}