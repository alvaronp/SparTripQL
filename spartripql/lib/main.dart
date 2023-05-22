import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spartripql/info.dart';
import 'map.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SparTripQL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'SparTripQL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool touched = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
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
        title: Row(
            children: [
              Text(widget.title, style: const TextStyle(fontFamily: "SFPro", fontWeight: FontWeight.bold)),
            ]),
        actions:[
          IconButton(
              splashRadius: 20,
              onPressed: (){
                setState(() {
                  touched = !touched;
                });
              },
              icon: Icon(touched ? Icons.arrow_drop_down_circle_sharp : Icons.arrow_drop_down_circle_outlined)
          ),
          IconButton(
          splashRadius: 20,
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()));
            },
            icon: const Icon(Icons.info)
        )
        ],
      ),
        body: Map(touched: touched),
    );
  }
}
