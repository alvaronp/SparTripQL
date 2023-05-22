import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spartripql/components/openrouteservice.dart';
import 'package:spartripql/components/sparqlqueries.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:spartripql/widgets/datasetActivator.dart';
import 'package:spartripql/widgets/slidable_panel.dart';
import 'components/geolocate.dart';
import 'package:google_maps_utils/google_maps_utils.dart' as geoutils;
import 'dart:math';

import 'components/queries.dart';

class Map extends StatefulWidget {
  Map({Key? key, required this.touched}) : super(key: key);
  final bool touched;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  late MapController _mapController;
  late SuperclusterMutableController _mutableController;
  late Position myPos;
  late List<Marker> _markers;
  late List<Marker> _position;
  late List<Marker> _sites;
  late List<Polyline> _polylines;
  late List<latlng.LatLng> _linePoints;
  double maxDistance = 10;
  final panelController = PanelController();

  List<datasetButton> datasets =
  [datasetButton("Iglesias", Colors.amber, false),
    datasetButton("Monumentos", Colors.orange, false),
    datasetButton("Museos", Colors.indigo, false),
    datasetButton("Farmacias", Colors.green, false),
    datasetButton("Restaurantes", Colors.red, false),
    datasetButton("Bar/Cafeterías", Colors.brown, false),
    datasetButton("Polideportivos", Colors.blue, false)];

  @override
  void initState() {
    _mapController = MapController();
    _mutableController = SuperclusterMutableController();
    super.initState();
    _markers = [];
    _position = [];
    _sites = [];
    _polylines = [];
    _linePoints = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            splashColor: Colors.grey,
            backgroundColor: Colors.brown,
            onPressed: () async {
              //ADD RUTA
              if(_markers.length == 2) {
                _polylines.clear();
                getJsonData().whenComplete(() => getSparQLData(datasets, maxDistance));
              }
            },
            tooltip: 'Crear ruta',
            heroTag: 'rute_add',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            splashColor: Colors.grey,
            backgroundColor: Colors.brown,
            onPressed: () async {
              if(_position.isNotEmpty) {
                _position.removeLast();
              }
              myPos = await Geolocate.determinePosition();
              _mapController.move(latlng.LatLng(myPos.latitude, myPos.longitude), 14.5);
              _position.add(
                  Marker(
                    key: const Key("position"),
                    point: latlng.LatLng(myPos.latitude, myPos.longitude),
                    builder: (_) => const Icon(Icons.account_circle_rounded,color: Colors.teal, size: 30),
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    rotate: false,
                  )
              );
              },
            tooltip: 'Geolocalizar',
            heroTag: 'maps_geoloc',
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: latlng.LatLng(39.473882, -6.372352),
            zoom: 14,
            minZoom: 12.5,
            maxZoom: 18,
            onLongPress: (tapPosition, point) {
              setState(() {
                _markers.add(
                    Marker(
                      rotate: false,
                      point: point,
                        builder: (_) => GestureDetector(
                            onTap: () => print("TOCADO"),
                            child: const Icon(Icons.location_on, size: 40)),
                    )
                );
                if(_markers.length > 2){
                  _markers.removeAt(0);
                }
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',//'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'es.alnietop.sparql',
            ),
            PolylineLayer(
              polylines: _polylines, //Para las rutas generadas con OpenRouteService
            ),
            SuperclusterLayer.mutable(
                initialMarkers: _sites,
                anchor: AnchorPos.align(AnchorAlign.center),
                controller: _mutableController,
                clusterZoomAnimation: const AnimationOptions.animate(curve: Curves.easeIn, duration: Duration(seconds: 200)),
                clusterWidgetSize: const Size(30, 30),
                maxClusterRadius: 80,
                maxClusterZoom: 15,
                builder: (context, position, markerCount, extraClusterData) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.brown),
                    child: Center(
                      child: Text(
                        markerCount.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
            MarkerLayer(
              markers: _position, //Para marcador de geolocalización
            ),
            MarkerLayer(
              markers: _markers, //Para marcadores de inicio y fin de ruta
            ),
          ],
        ),
          Visibility(
            maintainState: true,
            visible: widget.touched,
            maintainSize: true,
            maintainAnimation: true,
            child: Container(
              height: 55,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                  itemCount: datasets.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return datasetActivator(
                        dataset: datasets[index],
                        imageUrl: imageUrls[index],
                    );
                  }),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            bottom: 10,
            child: Slider(
              divisions: 2000,
              label: "${maxDistance.toStringAsPrecision(5)} metros",
              value: maxDistance,
              onChanged: (value) {
                setState(() {
                  maxDistance = value;
                });
                },
              max: 2000,
              inactiveColor: Colors.brown.shade300,
              min: 10,
              activeColor: Colors.brown.shade700,
            ),
          )
        ],
      ),
    );
  }

  setPolyLines() async{
    Polyline polyline = Polyline(
      color: Colors.teal,
      borderColor: Colors.blueAccent,
      points: _linePoints,
      borderStrokeWidth: 2,
      strokeWidth: 3,
    );
    Polyline recta = Polyline(
      color: Colors.grey,
      borderColor: Colors.blueGrey,
      points: [_linePoints.first, _linePoints.last],
      borderStrokeWidth: 0.5,
      strokeWidth: 1,
    );
    setState(() {
      _polylines.add(recta);
      _polylines.add(polyline);
    });
  }


  Future getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    OpenRouteService ors = OpenRouteService(
      startLat: _markers.first.point.latitude,
      startLng: _markers.first.point.longitude,
      endLat: _markers.last.point.latitude,
      endLng: _markers.last.point.longitude,
    );

    try {
      // getData() returns a json Decoded data
      var data = await ors.getData();
      _linePoints = [];
      // We can reach to our desired JSON data manually as following
      LineString ls =
      LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        _linePoints.add(latlng.LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (_linePoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
    }
  }

  void getSparQLData(List<datasetButton> datasets, double maxDistance) async {
    _mutableController.clear();
    for (datasetButton dataset in datasets) {
      if(dataset.active) {
        SparqlQueries spql = SparqlQueries(
            dataset: dataset.name,
            rute: _polylines.last
        );
        try {
          // getData() returns a json Decoded data
          var data = await spql.getData();
          LineString ls =
          LineString(data['results']['bindings']);

          for (int i = 0; i < ls.lineString.length; i++) {
            latlng.LatLng point = latlng.LatLng(
                double.parse(ls.lineString[i]['geo_lat']['value']),
                double.parse(ls.lineString[i]['geo_long']['value']));
            final distance = geoutils.PolyUtils.distanceToLine(
                Point(point.latitude, point.longitude), Point(
                _polylines.last.points.first.latitude,
                _polylines.last.points.first.longitude), Point(
                _polylines.last.points.last.latitude,
                _polylines.last.points.last.longitude));
            // si la distancia entre algun punto de la ruta y el objeto del dataset
            // de Sparql es menor a [maxDistance] metros, aparecerá su marker en el mapa
            if (distance < maxDistance) {
              Marker m = markerDataQuery(dataset, point, ls.lineString[i]);
              setState(() {
                _mutableController.add(m);
              });
            }
          }
        }
        catch (e) {
          print(e);
        }
      }
    }
  }

  ///Método para crear el BottomSheet de obtención de un campo [Field] desde la sede del Catastro
  void showInfoSheet(latlng.LatLng point, String dataset, lineString) {
    showModalBottomSheet<dynamic>(
        barrierColor: Colors.transparent,
        context: context,
        elevation: 0,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext builder) {
          return Wrap(
            children: [
              SlidingUpPanel(
                color: Colors.white,
                controller: panelController,
                panelBuilder: (controller) => SlidablePanel(
                  dataset: dataset,
                  controller: controller,
                  panelController: panelController,
                  lineString: lineString,
                  point: point,
                ),
                minHeight: MediaQuery.of(context).size.height * 0.25,
                maxHeight: MediaQuery.of(context).size.height * 0.865,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              )
            ],
          );
        });
  }

  Marker markerDataQuery(datasetButton dataset, latlng.LatLng point, lineString) {
    double size = 30;
    var icons = {'Iglesias':Icon(FontAwesomeIcons.church, size: size, color: dataset.color),
                  'Monumentos':Icon(FontAwesomeIcons.gopuram, size: size, color: dataset.color),
                  'Museos':Icon(Icons.museum_rounded, size: size, color: dataset.color),
                  'Farmacias':Icon(FontAwesomeIcons.staffSnake, size: size, color: dataset.color),
                  'Restaurantes':Icon(FontAwesomeIcons.utensils, size: size, color: dataset.color),
                  'Bar/Cafeterías':Icon(FontAwesomeIcons.mugSaucer, size: size, color: dataset.color),
                  'Polideportivos':Icon(FontAwesomeIcons.dumbbell, size: 30, color: dataset.color)};
    Marker m = Marker(
      point: point,
      builder: (context) {
        return GestureDetector(
          onTap: (){
            print(lineString['nombre']['value']);
            showInfoSheet(point, dataset.name, lineString);
            },
          child: icons[dataset.name],
        );
        },
    );
    return m;
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}

class datasetButton {
  datasetButton(this.name, this.color, this.active);
  String name;
  MaterialColor color;
  bool active;
}