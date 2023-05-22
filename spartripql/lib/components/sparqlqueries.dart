import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spartripql/components/queries.dart';

class SparqlQueries{
  SparqlQueries({required this.dataset, required this.rute});

  final String dataset;
  final Polyline rute;
  String query = "";
  final String endpoint = 'http://opendata.caceres.es/sparql';

  Future getData() async{
    switch (dataset){
      case "Iglesias":
        query = queryReligioso;
        break;
      case "Monumentos":
        query = queryMonum;
        break;
      case "Museos":
        query = queryMuseos;
        break;
      case "Farmacias":
        query = queryFarmacias;
        break;
      case "Restaurantes":
        query = queryRestaurantes;
        break;
      case "Bares y cafeterías":
        query = queryBarCafes;
        break;
      case "Polideportivos":
        query = queryCentrosDeportivos;
        break;
    }
    Uri uri = Uri.parse('$endpoint?default-graph-uri=&query=$query&format=json');
    print(uri);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }
}