import 'dart:io';
import 'package:pie_chart/pie_chart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:provider/provider.dart';

class  HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override

  void initState(){

    final socketService = Provider.of<SocketService>(context, listen: false);

    //Listener 
    socketService.socket.on('active-bands',_handleActiveBands);
    super.initState();
  }

  _handleActiveBands( dynamic payload){
        this.bands = (payload as List)
                    .map((band) => Band.fronMap(band)).toList();
                    setState(() {    });
  }

  void dispose(){
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
        
    return Scaffold(
      appBar: AppBar(
          title: Text('BandNames',style: TextStyle(color:Colors.black87),),
          backgroundColor: Colors.white,
          elevation: 1,   
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: 
                 socketService.serverStatus==ServerStatus.OnLine ? Icon(Icons.check_circle,color: Colors.green,) :Icon(Icons.offline_bolt,color: Colors.red,),              
            )              
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: <Widget>[
              _showGraph(),
              bandList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
      );
  }

bandList() {
    return Expanded(
      child: ListView.builder(
          itemCount: bands.length,
          itemBuilder: ( context, i) =>  bandTile(bands[i])
      ),
    );
  }

  Widget bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: backgroundDessmBandTile(),
      onDismissed: (direction) => socketService.socket.emit('delete-band',{'band_id': band.id}),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[100],
            ),
          title: Text(band.name),
          trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
          onTap: () => socketService.socket.emit('vote-band',{'band_id': band.id}),
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
        builder: ( _ ) =>AlertDialog(
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
            ),
      );
    }  
    // Para IOS
    showCupertinoDialog(
        context: context, 
        builder: (_) =>  CupertinoAlertDialog(
              title: Text('New Band Name'),
              content: CupertinoTextField(
                    controller: textEditingController,
                ),
             actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Add'),
                    onPressed: (){ 
                        addBandToList(textEditingController.text);
                                                Navigator.pop(context);
                    }
                  ),
                  CupertinoDialogAction(
                    child: Text('Dismiss'),
                    onPressed: (){ 
                        Navigator.pop(context);
                    }
                  ),
                ],
          ),
    );
  }

  void addBandToList(String name){

    if(name.length>1){

    final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band',{'name': name});
    }
  }

  Widget _showGraph() {

      Map<String, double> dataMap = new Map();
      bands.forEach((band) { 
          dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      });
     return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
         chartValuesOptions: ChartValuesOptions(showChartValueBackground: false),
         chartType: ChartType.ring,
          )
      ) ;
          
  }



}