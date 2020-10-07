import 'package:flutter/material.dart';
import 'package:api_si/perfis.dart';
import 'package:api_si/perfis_update.dart';
import 'package:api_si/api/api_service.dart';
import 'package:api_si/model/profile.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Perfis extends StatefulWidget {
  @override
  _PerfisState createState() => _PerfisState();
}

class _PerfisState extends State<Perfis> {

  ApiService apiService;
  List<Profile> profiles;
  TextEditingController campoBusca = TextEditingController();
  String busca = "";

  @override
  void initState(){
    super.initState();
    apiService = ApiService();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Cadastro de Perfis"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool resposta = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PerfisUpdate())
          );
          if (resposta==true){
            setState(() {});
          }


        },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
              controller: campoBusca,
              decoration: InputDecoration(
                hintText: "Busca Por Nome",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (texto){
                setState(() {
                  busca = texto;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: apiService.getProfiles(),
              builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot){
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Algo deu errado : ${snapshot.error.toString()} "),
                  );
                } else if (snapshot.connectionState == ConnectionState.done){
                  profiles = snapshot.data;
                  return montaLista(profiles, context);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget montaLista(List<Profile> profiles, context){
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return profiles[index].name.toLowerCase().contains(busca.toLowerCase()) ? Card(
            child: ListTile(
              isThreeLine: true,
              title: Text(profile.name),
              subtitle: Text(profile.email + " \n" + profile.age.toString(),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      bool resposta = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PerfisUpdate(profile: profile,))
                      );
                      if (resposta==true){
                        setState(() {});
                      }

                    },
                  ),
                  IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      confirmaExclusao(profile.name, profile.id);
                    },
                  ),
                ],
              ),
            ),
          ) : Container();
        },
      ),

    );
  }

  Widget confirmaExclusao(String nome, int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Atenção"),
            content: Text("Confirme a exclusão de : \n ${nome}"),
            actions: <Widget>[
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  apiService.deleteProfile(id).then((isSucess){
                    if (isSucess) {
                      setState(() {});
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        content: Text("Registro excluído com sucesso !"),
                      ));
                    } else {
                      Scaffold.of(this.context).showSnackBar(SnackBar(
                        content: Text("Erro na exclusão"),
                      ));
                    }
                  });


                },
              ),
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.pop(context);
               },
              ),
            ],

          );
      }
    );
  }

}

