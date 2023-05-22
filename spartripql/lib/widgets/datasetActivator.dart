import 'package:flutter/material.dart';
import 'package:spartripql/map.dart';

class datasetActivator extends StatefulWidget {
  datasetActivator({super.key, required this.dataset, required this.imageUrl});
  final datasetButton dataset;
  final imageUrl;

  @override
  State<datasetActivator> createState() => _datasetActivatorState();
}

class _datasetActivatorState extends State<datasetActivator> {
  bool getState(){
    return widget.dataset.active;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.dataset.active = !widget.dataset.active;
          print(widget.dataset.active);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5,left: 10),
        child: Container(
          alignment: Alignment.center,
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(blurRadius: 2, blurStyle: BlurStyle.solid)]
          ),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.imageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: widget.dataset.active ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.6),
                  )),
              Center(
              child: Text(widget.dataset.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}