import 'package:api_si/perfis.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste com API"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Cadastro de Perfis"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Perfis()));
              },
            )
          ],
        ),
      ),
    );
  }
}
