import 'package:flutter/material.dart';
import 'package:justmenu/constants.dart';
import 'package:justmenu/data.dart';
import 'package:justmenu/imagePicker.dart';

class ViewPage extends StatelessWidget {
  final JustMenu justMenu;
  final Function sendConfiguredDataToBackend;
  ViewPage({
    @required this.justMenu,
    @required this.sendConfiguredDataToBackend,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(justMenu.name),
          backgroundColor: kThemeColor,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "+ Add Menu",
                style: kTitleStyle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePickerPage(
                      justMenu: justMenu,
                      sendConfiguredDataToBackend: sendConfiguredDataToBackend,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: justMenu.menu.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Image.network(
                              justMenu.menu[index],
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              sendConfiguredDataToBackend({
                                "justmenu_id": justMenu.oid,
                                "image_url": justMenu.menu[index]
                              }, "delimage_justmenu");
                            },
                          ),
                          Divider(
                            thickness: 3,
                            indent: 24,
                            endIndent: 24,
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
