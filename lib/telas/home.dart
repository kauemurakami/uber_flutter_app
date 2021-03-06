import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uberflutterapp/model/usuario.dart';
import 'package:uberflutterapp/routes/routes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  bool _carregando = false;

  _validarCampos() {
    //recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    //validar
      if (email.isNotEmpty && email.contains('@')) {
        if (senha.isNotEmpty && senha.length > 6) {
          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;

          _logarUsuario(usuario);

        } else {
          setState(() {
            _mensagemErro = "Informe uma senha com mais de 6 digitos";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Informe um email válido";
        });
      }
  }

  _recuperaTipoUsuario(String idUsuario) async{
    Firestore firestore = Firestore.instance;
    DocumentSnapshot snapshot = await firestore
        .collection("usuarios")
        .document(idUsuario)
        .get();

    Map<String, dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];
    print(dados["tipoUsuario"]);

    setState(() {
      _carregando = false;
    });

    switch(tipoUsuario){
      case "motorista":
        Navigator.pushReplacementNamed(
            context,
            Routes.ROUTE_PAINEL_MOTORISTA);
        break;
      case "passageiro":
        Navigator.pushReplacementNamed(
            context,
            Routes.ROUTE_PAINEL_PASSAGEIRO);
        break;
    }
  }

  _logarUsuario(Usuario usuario){
    setState(() {
      _carregando = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then(
        (firebaseUser){
          _recuperaTipoUsuario(firebaseUser.user.uid);
        }).catchError((onError){
          _mensagemErro = "Erro ao autenticar usuário, verifique email e senha";
    });
  }

  _verificaUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if(usuarioLogado != null){
      String idUsuario = usuarioLogado.uid;
      _recuperaTipoUsuario(idUsuario);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/fundo.png"),
            fit: BoxFit.cover
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("images/logo.png",
                  width: 200,
                  height: 159,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 20
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "e-mail",
                    filled: true,
                    fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius : BorderRadius.circular(6)
                      )
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(
                      fontSize: 20
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius : BorderRadius.circular(6)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                        "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                    color: Color(0xff1ebbd8),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    onPressed: (){
                      _validarCampos();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                        "Não tem conta? Cadastre-se",
                      style:TextStyle(
                        color: Colors.white
                      )
                    ),
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          Routes.ROUTE_CADASTRO
                      );
                    },
                  ),
                ),
                _carregando
                    ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),)
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
