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
  List<String?> list = [];

  @override
  void initState() {
    super.initState();
    widget.dataset == "Iglesias" || widget.dataset == "Monumentos" || widget.dataset == "Museos" || widget.dataset == "Farmacias" ? _getData() : Container();
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
            widget.dataset == "Monumentos" ? buildMonumData() :
            widget.dataset == "Museos" ? buildMuseosData() :
            widget.dataset == "Restaurantes" ? buildRestData() :
            widget.dataset == "Bar/Cafeterías" ? buildBarData() :
            widget.dataset == "Farmacias" ? buildFarmData() :
            widget.dataset == "Polideportivos" ? buildDeportData() : Container (),
        const SizedBox(height: 26),
      ],
    );
  }

  void _getData() async { //Extraer imágenes de la web del SIG
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
                            print(error);
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
            widget.lineString['clase']['value'].toString().toCapitalized() + widget.lineString['nombre']['value'],
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

  ///Método para construir un [Widget] con todos los datos extraídos de Museo
  Widget buildMuseosData() {
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

  ///Método para construir un [Widget] con todos los datos extraídos de Restaurante
  Widget buildRestData() {
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
                    "Categoría",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['categoria']['value'] + "ª clase",
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Capacidad del local",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['capacidad']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Teléfono de contacto",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['telef'] == null ? "No disponible": widget.lineString['telef']['value'],
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Método para construir un [Widget] con todos los datos extraídos de Bar/Cafetería
  Widget buildBarData() {
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
                    "Capacidad del local",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['capacidad'] == null ? "No disponible": widget.lineString['capacidad']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Teléfono de contacto",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['telef'] == null ? "No disponible": widget.lineString['telef']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "E-mail",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['email'] == null ? "No disponible": widget.lineString['email']['value'],
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Método para construir un [Widget] con todos los datos extraídos de Farmacia
  Widget buildFarmData() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Farmacia " + widget.lineString['nombre']['value'],
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
                    "Horarios",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    widget.lineString['Horario_de_manana_Opens'] == null ? "Horario de mañana no disponible":  "Horario de mañana: " + widget.lineString['Horario_de_manana_Opens']['value'] + "- " + widget.lineString['Horario_de_manana_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  Text(
                    widget.lineString['Horario_de_tarde_verano_Opens'] == null ? "Horario de tarde de verano no disponible":  "Horario de tarde (verano): " + widget.lineString['Horario_de_tarde_verano_Opens']['value'] + "- " + widget.lineString['Horario_de_tarde_verano_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  Text(
                    widget.lineString['Horario_de_tarde_invierno_Opens'] == null ? "Horario de tarde de invierno no disponible":  "Horario de tarde (invierno): " + widget.lineString['Horario_de_tarde_invierno_Opens']['value'] + "- " + widget.lineString['Horario_de_tarde_invierno_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  Text(
                    widget.lineString['Horario_Extendido_Opens'] == null ? "Horario extendido no disponible":  "Horario extendido: " + widget.lineString['Horario_Extendido_Opens']['value'] + "- " + widget.lineString['Horario_Extendido_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Teléfono de contacto",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['telef'] == null ? "No disponible":  widget.lineString['telef']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "E-mail",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  Text(
                    widget.lineString['email'] == null ? "No disponible":  widget.lineString['email']['value'],
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
                            print(error);
                            print(list[0]);
                            return const Text(
                              "No hay imagen para este elemento",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54),
                            );
                          },
                          "https://sig.caceres.es${list[0]!}".replaceAll(RegExp(r' '), ''),
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

  ///Método para construir un [Widget] con todos los datos extraídos de Instalación Deportiva
  Widget buildDeportData() {
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
                    "Horarios",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    widget.lineString['Horario_Verano_Opens'] == null ? "Horario de verano no disponible": "Horario de verano: " + widget.lineString['Horario_Verano_Opens']['value'] + " - " + widget.lineString['Horario_Verano_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  Text(
                    widget.lineString['Horario_Invierno_Opens'] == null ? "Horario de invierno no disponible": "Horario de invierno: " + widget.lineString['Horario_Invierno_Opens']['value'] + " - " + widget.lineString['Horario_Invierno_Closes']['value'],
                    style: const TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
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

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
