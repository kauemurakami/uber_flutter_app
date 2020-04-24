import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:uberflutterapp/routes/routes.dart';

class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  CameraPosition _posicaoCamera = CameraPosition(
  target: LatLng(-23.563999, -46.653256),);

  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  Completer<GoogleMapController> _controller = Completer();

  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, Routes.ROUTE_ROOT);

  }

  _escolhaMenuItem( String escolha ){

    switch( escolha ){
      case "Deslogar" :
        _deslogarUsuario();
        break;
      case "Configurações" :

        break;
    }

  }

  _onMapCreated( GoogleMapController controller )async{
    _controller.complete( controller );
  }

  _recuperarUltimalocalizacao() async{
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if(position != null){
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19
        );
        _movimentarCamera(_posicaoCamera);
      }else{

      }
    });
  }
  _adicionaListenerALocalizacao(){
      var geolocator = Geolocator();
      var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      geolocator.getPositionStream(locationOptions).listen((Position position){
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19
        );
        _movimentarCamera(_posicaoCamera);
      });
  }

  _movimentarCamera(CameraPosition cameraPosition) async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarUltimalocalizacao();
    _adicionaListenerALocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel passageiro"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){

              return itensMenu.map((String item){

                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );

              }).toList();

            },
          )
        ],
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}