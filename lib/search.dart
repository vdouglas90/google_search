import 'package:flutter/material.dart';
import 'package:google_search/aux.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late List<dynamic> temp = [];
  late List<Widget> resultadoPesquisa = [];
   String pesquisa = "";
   bool isLoading = false;

  Future<void> onSendMessage(String content)async {
    FocusManager.instance.primaryFocus?.unfocus();


    if (content.trim() != ''){
      temp = await Aux.search(content) as List;
      temp.forEach((mapa1) {
        pesquisa = "${mapa1["title"]} ----  ${mapa1["url"]}";
        setState(() {
          resultadoPesquisa.add(
              Column(
                children: [
                  SizedBox(height: 10,),
                  Text("${mapa1["title"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  InkWell(
                      onTap: (){
                        launchUrl(Uri.parse("${mapa1["url"]}"));
                      },
                      child: Text("${mapa1["url"]}",style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),)),
                  SizedBox(height: 10,),
                  Divider(),
                ],
              )

          );
        });
        //print("${mapa1["title"]} ----  ${mapa1["url"]}");
      });

    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nada para enviar")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.deepOrange,
          child: Icon(Icons.restart_alt),
          onPressed:()=> setState(() {
        resultadoPesquisa = [];
      })),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFBC02D),
                Color(0xFFFFFEB3B),
                Color(0xFFFFFEB3B),
                Color(0xFFFBC02D),
              ],
            ),
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 15,right: 15),
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height*0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange[900],//Colors.indigo.withOpacity(f0.2),//
                    borderRadius:BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          child: TextField(
                            onSubmitted: (value) {
                              onSendMessage(textEditingController.text);
                            },
                            style: TextStyle(color: Colors.white, fontSize:15.0),
                            controller: textEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText:'Faça sua pergunta...',
                                hintStyle:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) ,
                            focusNode: focusNode,
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),color: Colors.white,
                          onPressed: ()async{
                            setState(() {
                              resultadoPesquisa = [];
                              isLoading = true;
                            });
                            await onSendMessage(textEditingController.text);
                            setState(() {
                              isLoading = false;
                            });
                          }),
                    ],
                  ),
                ),

                if(isLoading) Center(child: CircularProgressIndicator(),)
                else Column(
                  children: resultadoPesquisa
                )
              ],
            ),
          ),
      ),

    );
  }
}
