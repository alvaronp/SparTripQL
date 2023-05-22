import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;


///[StatefulWidget] que implementa toda la información extraida del Catastro en un SlidingUpPanel, controlado por [panelController]
class SlidablePanel extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final LatLng point;
  final lineString;
  final String dataset;

  const SlidablePanel({
    Key? key,
    required this.controller,
    required this.panelController,
    this.lineString,
    required this.point,
    required this.dataset,
  }) : super(key: key);

  @override
  State<SlidablePanel> createState() => _SlidablePanelState();
}

class _SlidablePanelState extends State<SlidablePanel> {
  bool _err = false;
  List<String?> list = [];

  @override
  void initState() {
    super.initState();
    widget.dataset == "Iglesias" ? _getData() : Container();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: widget.controller,
      shrinkWrap: true,
      children: <Widget>[
        const SizedBox(height: 10),
        buildDragPill(),
        const SizedBox(height: 26),
        widget.dataset == "Iglesias" ? buildIglesiasData() :
            widget.dataset == "Monumentos" ? buildMonumData() : Container(), /*
            widget.dataset == "Museos" ? buildMuseosData() :
            widget.dataset == "Restaurantes" ? buildRestData() :
            widget.dataset == "Bar/Cafeterías" ? buildBarData() :
            widget.dataset == "Farmacias" ? buildFarmData() :
            widget.dataset == "Polideportivos" ? buildDeportData(),*/
        const SizedBox(height: 26),
      ],
    );
  }

  void _getData() async { //Extraer imágenes de la web del SIG si es una Iglesia/Monumento
    final response = await http.get(Uri.parse(widget.lineString['sig']['value']));
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName('contenedor-imagen');

    setState(() {
      list = elements
          .map((element) =>
      element.getElementsByTagName("img")[0].attributes['src'])
          .toList();
    });
  }

  ///Método para construir un [Widget] con todos los datos extraídos de Iglesia
  Widget buildIglesiasData() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.lineString['nombre']['value'].toString().contains("Otros") ? widget.lineString['nombre']['value'].toString().split("Otros ")[1] : widget.lineString['nombre']['value'],
            style: const TextStyle(
                fontFamily: "SFPro", fontWeight: FontWeight.bold, fontSize: 30
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.point.latitude.toStringAsFixed(5) +
                ", " +
                widget.point.longitude.toStringAsFixed(5),
            style: const TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black54),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tipo de centro religioso",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['tipo']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Web",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['web'] == null ? "No disponible":  widget.lineString['web']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enlace SIG",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        widget.lineString['sig']['value'],
                        style: const TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      list.isEmpty ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.brown,
                        ),
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          errorBuilder:(context, error, stackTrace) {
                            return const Text(
                              "No hay imagen para este elemento",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54),
                            );
                          },
                          "https://sig.caceres.es${list[0]!}",
                          alignment: Alignment.topLeft,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Método para construir un [Widget] con todos los datos extraídos de Monumento
  Widget buildMonumData() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.lineString['nombre']['value'],
            style: const TextStyle(
                fontFamily: "SFPro", fontWeight: FontWeight.bold, fontSize: 30
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.point.latitude.toStringAsFixed(5) +
                ", " +
                widget.point.longitude.toStringAsFixed(5),
            style: const TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black54),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Clase de monumento",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['clase']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enlace SIG",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        widget.lineString['sig']['value'],
                        style: const TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      list.isEmpty ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.brown,
                        ),
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          errorBuilder:(context, error, stackTrace) {
                            return const Text(
                              "No hay imagen para este elemento",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54),
                            );
                          },
                          "https://sig.caceres.es${list[0]!}",
                          alignment: Alignment.topLeft,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Widget para agarrar el SlidingUpPanel
  Widget buildDragPill() {
    return GestureDetector(
      onTap: quickDisplay,
      child: Center(
        child: Container(
          width: 30,
          height: 6,
          decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }

  ///Método para abrir y cerrar el panel rápidamente
  void quickDisplay() {
    widget.panelController.isPanelOpen
        ? widget.panelController.close()
        : widget.panelController.open();
  }
}
