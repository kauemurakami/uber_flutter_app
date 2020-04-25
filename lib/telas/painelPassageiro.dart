import 'dart:io';
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

  TextEditingController _controllerLocal = TextEditingController();

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
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border : Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white
                  ),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, bottom: 15),
                        width: 10,
                        height: 10,
                        child: Icon(Icons.location_on, color: Colors.green ,),
                      ),
                      hintText: "Meu Local",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, top: 15, bottom: 15)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(Icons.local_taxi, color: Colors.grey ,),
                        ),
                        hintText: "Digite seu destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, top: 15, bottom: 15)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS ? EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 25)
                : EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text(
                    "Chamar Uber",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                  color: Color(0xff1ebbd8),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: (){

                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}