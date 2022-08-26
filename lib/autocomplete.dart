import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutoComplete extends StatefulWidget {
  const AutoComplete({Key? key}) : super(key: key);

  @override
  State<AutoComplete> createState() => _AutoComplete();
}

class _AutoComplete extends State<AutoComplete> {
  List<String> places = [];
  String name = "Please Selected";

  @override
  void initState() {
    super.initState();
    findplace();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AutoComplete"),
      ),
      body: ListView(
        children: [
          new Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.blueAccent
                )
            ),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue){
                if(textEditingValue == ''){
                  return const Iterable<String>.empty();
                }
                return places.where((String option){
                  return option.contains(textEditingValue.text);
                });
              },
              onSelected: (String selected){
                debugPrint("You just selected $selected");
                setState((){
                  name = selected;
                });
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted
                  ){
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search)
                  ),
                  style: const TextStyle(color: Colors.blueGrey, fontSize:18),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void findplace() async{
    Uri url = Uri.parse('https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province.json');
    var response = await http.get(url);
    var data = json.decode(response.body);
    try{
      for(int i =0; i<data.toString().length; i++){
        setState((){
          String name2 = data[i]["name_th"].toString();
          places.add(name2);
          print(name2);
        });
      }
    }catch(error){

    }
  }
}
