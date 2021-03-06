//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
    OnLine,
    OffLine,
    Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket = IO.io('http://192.168.0.93:3000/',{
    'transports': ['websocket'],
    'autoConnect': true
  });
 
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;


  // Constructor
  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
// Dart client
  this._socket = IO.io('http://192.168.0.93:3000/',{
    'transports': ['websocket'],
    'autoConnect': true
  });

  this._socket.on('connect',(_) {
    this._serverStatus = ServerStatus.OnLine;
    notifyListeners();
  });

  this._socket.on('disconnect',(_) {
    this._serverStatus = ServerStatus.OffLine;
    notifyListeners();
  });

  }
}