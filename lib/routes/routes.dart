import 'package:flutter/material.dart';
import 'package:uberflutterapp/telas/cadastro.dart';
import 'package:uberflutterapp/telas/home.dart';
import 'package:uberflutterapp/telas/painelMotorista.dart';
import 'package:uberflutterapp/telas/painelPassageiro.dart';

class Routes{

  static const String ROUTE_ROOT = "/";
  static const String ROUTE_CADASTRO = "/cadastro";
  static const String ROUTE_PAINEL_MOTORISTA = "/painel-motorista";
  static const String ROUTE_PAINEL_PASSAGEIRO = "/painel-passageiro";

  static Route<dynamic> routeGenerator(RouteSettings settings){
    switch(settings.name){

      case ROUTE_ROOT :
        return MaterialPageRoute(
          builder: (_) => Home()
        );

      case ROUTE_CADASTRO:
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );

      case ROUTE_PAINEL_PASSAGEIRO :
        return MaterialPageRoute(
            builder: (_) => PainelPassageiro()
        );

      case ROUTE_PAINEL_MOTORISTA :
        return MaterialPageRoute(
            builder: (_) => PainelMotorista()
        );

      default:
        _erroRota();


    }
  }
static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada"),
          ),
          body: Center(
            child: Text("Tela não encontrada"),
          ),
        );
      }
    );
}
}