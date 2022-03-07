import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

class  HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1',name: 'Metallica', votes: 5),
    Band(id: '2',name: 'Queen', votes: 1),
    Band(id: '3',name: 'Bon Jovi', votes: 2),
    Band(id: '4',name: 'Guns and Roses', votes: 3),        
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('BandNames',style: TextStyle(color:Colors.black87),),
          backgroundColor: Colors.white,
          elevation: 1,                    
      ),
      body: bandList(),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
      );
  }

  ListView bandList() {
    return ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i) =>  bandTile(bands[i])
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: backgroundDessmBandTile(),
      onDismissed: (direction) {
        // LLamar al borrado
      } ,
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[100],
            ),
          title: Text(band.name),
          trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
          onTap: () {
            print(band.name);
            },
        ),
    );
  }

  Container backgroundDessmBandTile() {
    return Container(
                  padding: EdgeInsets.only(left: 8.0),
                  color: Colors.red,
                  child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Delete band', style: TextStyle(color: Colors.white),)
                        ),
                  );
  }

  addNewBand() {
    
   TextEditingController textEditingController = TextEditingController();

    if(1==2){
      // Para Android
      return showDialog(
        context: context, 
        builder: ( context ) {
            return AlertDialog(
              title: Text('New Band Name'),
              content: TextField(
                controller: textEditingController,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: (){ 
                    addBandToList(textEditingController.text);
                  }
                  )
              ],
            );
        }
      );
    }  
    // Para IOS
    showCupertinoDialog(
        context: context, 
        builder: (_){
          return CupertinoAlertDialog(
              title: Text('New Band Name'),
              content: CupertinoTextField(
                    controller: textEditingController,
                ),
             actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Add'),
                    onPressed: (){ 
                        addBandToList(textEditingController.text);
                    }
                  ),
                  CupertinoDialogAction(
                    child: Text('Dismiss'),
                    onPressed: (){ 
                        Navigator.pop(context);
                    }
                  ),
                ],
          );
        }
    );
  }

  void addBandToList(String name){
    if(name.length>1){
      setState(() {  
            this.bands.add(Band(id: '24',name: name,votes: 0));
            Navigator.pop(context);
      });          
    }
  }
}