import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //on vérifie si AR Core est disponible
  print(await ArCoreController.checkArCoreAvailability());
  //on vérifie si il est installé sur le smartphone
  print(await ArCoreController.checkIsArCoreInstalled());

  //on lance notre classe principale
  runApp(MaterialApp(title:"mon appli",home:MyApp()));
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenue dans Flutter'),
        ),
        body:ListView(
            children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyArApp()));
                    },
                  title: Text("Application AR"),
                ),
          ]
        ),
    );
  }

}

class MyArApp extends StatefulWidget {
  @override
  _MyArAppState createState() => _MyArAppState();
}

class _MyArAppState extends State<MyArApp> {
  ArCoreController arCoreController;

  int swichObject=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mon application AR'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addSphere(ArCoreHitTestResult hit) async {

    final material = ArCoreMaterial(
        color: Colors.blue);
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.3,
    );
    final node = ArCoreNode(
      shape: sphere,
        position: hit.pose.translation ,
    );
    arCoreController.addArCoreNode(node);
    
  }

  Future _addCube(ArCoreHitTestResult hit) async {

    final material = ArCoreMaterial(
        color: Colors.red);
    final sphere = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: sphere,
      position: hit.pose.translation ,
    );
    arCoreController.addArCoreNode(node);

  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;

    if(swichObject==0) {
      _addSphere(hit);
    }else if(swichObject==1){
      _addCube(hit);
    }

    swichObject++;
    if(swichObject>1){
      swichObject=0;
    }

  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('Vous avez cliqué sur le noeud $name')),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
