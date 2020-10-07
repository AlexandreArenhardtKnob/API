import 'package:flutter/material.dart';
import 'model/profile.dart';
import 'api/api_service.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class PerfisUpdate extends StatefulWidget {

  Profile profile;
  PerfisUpdate({this.profile});

  @override
  _PerfisUpdateState createState() => _PerfisUpdateState();
}

class _PerfisUpdateState extends State<PerfisUpdate> {

  ApiService apiService = ApiService();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String titulo = "";
  String textBotao = "";
  TextEditingController campoNome = TextEditingController();
  TextEditingController campoEmail = TextEditingController();
  TextEditingController campoIdade = TextEditingController();

  @override
  void initState() {
    if (widget.profile==null) { // inclusão de dados
      titulo = "Inclusão de Usuário";
      textBotao = "Incluir Dados";
      campoNome.text = "";
      campoEmail.text = "";
      campoIdade.text = "";
    } else { // alteração de dados
      titulo = "Alteração de Usuário";
      textBotao = "Alterar Dados";
      campoNome.text = widget.profile.name;
      campoEmail.text = widget.profile.email;
      campoIdade.text = widget.profile.age.toString();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: campoNome,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Informe o Nome"
                ),
                validator: (valor){
                  if (valor.isEmpty) {
                    return "Preencha o nome";
                  } else
                    return null;
                },
              ),
              TextFormField(
                controller: campoEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "E-Mail",
                    hintText: "Informe o Mail"
                ),
                validator: (valor){
                  if (valor.isEmpty) {
                    return "Preencha o Mail";
                  } else
                    return null;
                },
              ),
              TextFormField(
                controller: campoIdade,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Idade",
                    hintText: "Informe a Idade"
                ),
                validator: (valor){
                  if (valor.isEmpty) {
                    return "Preencha a Idade";
                  } else
                    return null;
                },
              ),
              Divider(),
              RaisedButton(
                color: Colors.blue,
                child: Text(textBotao),
                onPressed: (){
                  if (formkey.currentState.validate()){
                    String nome  = campoNome.text.toString();
                    String email = campoEmail.text.toString();
                    int idade = int.parse(campoIdade.text.toString());
                    Profile profile = Profile(name: nome, email: email, age: idade);
                    if (widget.profile==null) { // é uma inclusao
                      apiService.createProfile(profile).then((isSucess) {
                        if (isSucess) {
                          Navigator.pop(_scaffoldState.currentState.context, true);
                        } else {
                          _scaffoldState.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("A Inclusão de dados Flahou"),
                          ));
                        }
                      });

                    } else {
                      profile.id = widget.profile.id;
                      apiService.updateProfile(profile).then((isSucess) {
                        if (isSucess) {
                          Navigator.pop(_scaffoldState.currentState.context, true);
                        } else {
                          _scaffoldState.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("A Alteração de dados Falhou"),
                          ));
                        }
                      });

                    }
                  }



                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
