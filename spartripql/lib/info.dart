import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },
            icon: Icon(Icons.arrow_back_ios), color: Colors.white,),
        toolbarHeight: 70,
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          child: Image.asset('assets/images/caceres.jpg',
            fit: BoxFit.cover,
            alignment: AlignmentDirectional.center,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.65),
          ),
        ),
        elevation: 1,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
        title: const Row(
            children: [
              Text("Información de la app", style: TextStyle(fontFamily: "SFPro", fontWeight: FontWeight.bold)),
            ]),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),

        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 10,),
          Center(child: Text("Realizado por Álvaro Nieto Paredes para la asignatura de Ingeniería del Conocimiento", style: TextStyle(fontFamily: "SFPro", fontWeight: FontWeight.bold,fontSize: 20))),
          SizedBox(height: 10,),
          Image.asset('assets/images/logo.png'),
          SizedBox(height: 10,),
          Center(child: Text("Elementos utilizados", style: TextStyle(fontFamily: "SFPro", fontWeight: FontWeight.bold,fontSize: 15))),
          Row(
            children: [
              Image.asset('assets/images/opendata.png',scale: 3),
              Image.asset('assets/images/sig.png',scale: 3),
              Image.asset('assets/images/openrouteserv.png',scale: 3),

            ],)
        ],
      ),
    );
  }
}
