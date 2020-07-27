import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:flutter/material.dart';
import 'package:justmenu/data.dart';
import 'package:justmenu/homePage.dart';
import 'package:justmenu/url.dart';

class Connection extends StatefulWidget {
  final String jwt;
  final String staffId;
  final String restaurantId;
  Connection({
    this.jwt,
    this.staffId,
    this.restaurantId,
  });
  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  List<JustMenu> justMenus;
  bool webSocketConnected = false;

  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};

  Map<String, bool> _isProbablyConnected = {};
  String kitchenStaffName, restaurantName, kitchenId, kitchenName;
  @override
  void initState() {
    super.initState();

    manager = SocketIOManager();

    justMenus = List<JustMenu>();

    initSocket(uri);
  }

  initSocket(uri) async {
    print('hey from init');
//    print(loginSession.jwt);

    var identifier = 'working';
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        uri,
        nameSpace: "/reliefo",
        //Query params - can be used for authentication
        query: {
          "jwt": widget.jwt,
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport

        ));
    socket.onConnect((data) {
      pprint({"Status": "connected..."});
      setState(() {
        webSocketConnected = true;
      });

      print("on Connected");
      print(data);

      socket.emit("check_logger", [" sending........."]);

      socket.emit("fetch_justmenu", ["Waiting to connect........."]);
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect((data) {
      print('object disconnnecgts');
    });

    socket.on("logger", (data) => pprint(data));
    socket.on("here_justmenu", (data) => fetchJustMenu(data));

    socket.on("justmenu_config", (data) => receiveConfiguredData(data));

    socket.connect();
    sockets[identifier] = socket;
  }

  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);

    setState(() {
      webSocketConnected = false;
      _isProbablyConnected[identifier] = false;
    });
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
    });
  }

  fetchJustMenu(data) {
    if (data is Map) {
      data = json.encode(data);
    }

    print(data);
    justMenus.clear();
    data.forEach((element) {
      JustMenu justMenu = JustMenu.fromJson(element);
      setState(() {
        justMenus.add(justMenu);
      });
    });
  }

  sendConfiguredDataToBackend(localData, type) {
    var encode;

    if (type == "add_justmenu") {
      localData['type'] = type;

      encode = jsonEncode(localData);
    }

    if (type == "delete_justmenu") {
      localData['type'] = type;

      encode = jsonEncode(localData);
    }

    if (type == "image_justmenu") {
      localData['type'] = type;

      encode = jsonEncode(localData);
    }

    if (type == "delimage_justmenu") {
      localData['type'] = type;

      encode = jsonEncode(localData);
    }
    print("before sending to cloud");
    print(encode);
    //todo: get sockets from socket connection
    sockets['working'].emit('justmenu_configuration', [encode]);
    print('uploded to cloud');
  }

  receiveConfiguredData(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    print("inside receive configured data");

    var decode = jsonDecode(data);

    print(decode);

    if (decode["type"] == "add_justmenu") {
      setState(() {
        JustMenu justMenu = JustMenu.fromJson(decode["justmenu_object"]);
        justMenus.add(justMenu);
      });

      print("rest added");
    }

    if (decode["type"] == "delete_justmenu") {
      setState(() {
        justMenus
            .removeWhere((element) => element.oid == decode["justmenu_id"]);
      });

      print("deleted rest");
    }

    if (decode["type"] == "image_justmenu") {
      print("image adding");
      print(decode);
      setState(() {
        justMenus.forEach((element) {
          if (element.oid == decode["justmenu_id"]) {
            element.menu.add(decode["image_url"]);
          }
        });
      });

      print("image added");
    }

    if (decode["type"] == "delimage_justmenu") {
      print("image deleting");
      print(decode);
      setState(() {
        justMenus.forEach((element) {
          if (element.oid == decode["justmenu_id"]) {
            element.menu.remove(decode["image_url"]);
          }
        });
      });

      print("image deleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
//        drawer: Drawer(
//          child: DrawerMenu(
//            kitchenName: kitchenName,
//            staffName: kitchenStaffName,
//            restaurantName: restaurantName,
//          ),
//        ),
        body: webSocketConnected == true
            ? HomePage(
                justMenus: justMenus,
                sendConfiguredDataToBackend: sendConfiguredDataToBackend,
              )
            : Container(
                child: Center(
                  child: Text("Websocket not connected"),
                ),
              ),
      ),
    );
  }
}
