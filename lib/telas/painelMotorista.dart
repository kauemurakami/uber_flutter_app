import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uberflutterapp/routes/routes.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  List<String> itensMenu =[
    "Configurações","Sair"
  ];

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(
        context,
        Routes.ROUTE_ROOT);
  }

  _escolhaItemMenu(String escolha){
    switch(escolha){
      case "Sair":
        _deslogarUsuario();
        break;
      case "Configurações":
      //config
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel motorista"),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _escolhaItemMenu,
              itemBuilder: (context){
                return itensMenu.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              }
          )
        ],
      ),
      body: Container(),
    );
  }
}
