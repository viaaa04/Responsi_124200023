import 'package:flutter/material.dart';
import 'matches_source.dart';
import 'detail_page.dart';
import 'matches_model.dart';
import 'package:drop_shadow/drop_shadow.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pertandingan Piala Dunia Qatar 2022"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          future:
          ListMatchesSource.instance.loadMatches(),

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              // debugPrint(snapshot.data);
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              return _buildSuccessSection(snapshot.data);
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildSuccessSection(List<dynamic> data) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              MatchesModel matchesModel = MatchesModel.fromJson(data[index]);
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: ((context) {
                      return DetailPage(id: matchesModel.id.toString(),);
                    })
                )),
                child: Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          DropShadow(
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                            spread: 1,
                            child: Image.network(
                              "https://countryflagsapi.com/png/${matchesModel.homeTeam?.name}",width: 150,height: 150,
                            ),
                          ),
                          //Image.network("https://countryflagsapi.com/png/${matchesModel.homeTeam?.name}",width: 150,height: 150,),
                          Text("${matchesModel.homeTeam?.name}"),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          ),
                        ],
                      ),
                      // Image.network("https://countryflagsapi.com/png/Qatar",width: 120,),
                      SizedBox(width: 40,),
                      Text("${matchesModel.homeTeam?.goals}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,  color: Colors.green,),),
                      SizedBox(width: 20,),
                      Text("-", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,  color: Colors.red,),),
                      SizedBox(width: 20,),
                      Text("${matchesModel.awayTeam?.goals}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,  color: Colors.green,),),
                      SizedBox(width: 40,),
                      Column(
                        children: [
                          DropShadow(
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                            spread: 1,
                            child: Image.network(
                              "https://countryflagsapi.com/png/${matchesModel.awayTeam?.name}",width: 150,height: 150,
                            ),
                          ),
                          //Image.network("https://countryflagsapi.com/png/${matchesModel.awayTeam?.name}",width: 150,height: 150,),
                          Text("${matchesModel.awayTeam?.name}"),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}