import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:justmenu/ViewPage.dart';
import 'package:justmenu/constants.dart';
import 'package:justmenu/data.dart';
import 'package:url_launcher/url_launcher.dart';

//void main() {
//  runApp(Scaffold(
//    body: Center(
//      child: RaisedButton(
//        onPressed: _launchURL,
//        child: Text('Show Flutter homepage'),
//      ),
//    ),
//  ));
//}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class HomePage extends StatefulWidget {
  final List<JustMenu> justMenus;

  final Function sendConfiguredDataToBackend;

  HomePage({
    @required this.justMenus,
    @required this.sendConfiguredDataToBackend,
  });
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<HomePage> {
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryEditController = TextEditingController();
  final _descriptionEditController = TextEditingController();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  bool _categoryValidate = false;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _addCategory() {
    setState(() {
      if (_categoryController.text.isNotEmpty) {
        _categoryValidate = false;

        widget.sendConfiguredDataToBackend({
          "name": _categoryController.text,
        }, "add_justmenu");

        _categoryController.clear();
        _descriptionController.clear();
      } else
        _categoryValidate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
//    final RestaurantData restaurantData = Provider.of<RestaurantData>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kThemeColor,
          title: Text('Add Restaurant'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        controller: _categoryController,
                        textInputAction: TextInputAction.next,
                        focusNode: _categoryFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _categoryFocus, _descriptionFocus);
                        },
                        decoration: InputDecoration(
                          labelText: "Restaurant Name",
                          fillColor: Colors.white,
                          errorText: _categoryValidate
                              ? 'Value Can\'t Be Empty'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          //fillColor: Colors.green
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
//                    Expanded(
//                      child: Container(
//                        padding: EdgeInsets.all(12),
//                        child: TextFormField(
//                          controller: _descriptionController,
//                          focusNode: _descriptionFocus,
//                          onFieldSubmitted: (value) {
//                            _addCategory();
//                          },
//                          decoration: InputDecoration(
//                            labelText: "Description",
//                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(12.0),
//                            ),
//                          ),
//                          keyboardType: TextInputType.text,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'Please enter Description';
//                            }
//                            return null;
//                          },
//                        ),
//                      ),
//                    ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: RaisedButton(
                      color: kThemeColor,
                      child: Text('Add'),
                      onPressed: () {
                        _addCategory();
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: widget.justMenus != null
                    ? ListView.builder(
                        itemCount: widget.justMenus.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return FlatButton(
                            child: ListTile(
                              title: Text(
                                widget.justMenus[index].name,
                                style: kTitleStyle,
                              ),
                              subtitle: Text(
                                '${formatDate(
                                      (widget.justMenus[index].created),
                                      [d, '/', M, '/', yy, '  ', HH, ':', nn],
                                    )}' ??
                                    " ",
                                style: kSubTitleStyle,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.file_download),
                                    onPressed: () {
                                      _launchURL(widget.justMenus[index].qr);
                                    },
                                  ),
//                                  IconButton(
//                                    icon: Icon(Icons.edit),
//                                    onPressed: () {
//                                      _categoryEditController.text =
//                                          widget.justMenus[index].name;
//
//                                        _descriptionEditController.text =
//                                            restaurantData.restaurant
//                                                .barMenu[index].description;
//                                      showDialog(
//                                        barrierDismissible: false,
//                                        context: context,
//                                        builder: (BuildContext context) {
//                                          // return object of type Dialog
//                                          return AlertDialog(
//                                            shape: RoundedRectangleBorder(
//                                              borderRadius:
//                                                  BorderRadius.circular(20),
//                                            ),
//                                            content: Column(
//                                              mainAxisSize: MainAxisSize
//                                                  .min, // To make the card compact
//                                              children: <Widget>[
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceBetween,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "Category : ",
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                      style: kTitleStyle,
//                                                    ),
//                                                    SizedBox(width: 20),
//                                                    Container(
//                                                      width: 200,
//                                                      child: TextField(
//                                                        controller:
//                                                            _categoryEditController,
//                                                        autofocus: true,
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                                SizedBox(height: 16.0),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceBetween,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "Description : ",
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                      style: kTitleStyle,
//                                                    ),
//                                                    SizedBox(width: 20),
//                                                    Container(
//                                                      width: 200,
//                                                      child: TextField(
//                                                        controller:
//                                                            _descriptionEditController,
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                                SizedBox(height: 24.0),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceAround,
//                                                  children: <Widget>[
//                                                    FlatButton(
//                                                      child: Text(
//                                                        "Cancel",
//                                                        style: TextStyle(
//                                                            fontFamily:
//                                                                "Poppins",
//                                                            color: Colors.red),
//                                                      ),
//                                                      onPressed: () {
//                                                        Navigator.of(context)
//                                                            .pop(); // To close the dialog
//                                                      },
//                                                    ),
//                                                    FlatButton(
//                                                      child: Text(
//                                                        "Done",
//                                                        style: TextStyle(
//                                                            fontFamily:
//                                                                "Poppins",
//                                                            color:
//                                                                Colors.green),
//                                                      ),
//                                                      onPressed: () {
//                                                        if (_categoryEditController
//                                                            .text.isNotEmpty) {
//                                                          widget
//                                                              .sendConfiguredDataToBackend(
//                                                            {
//                                                              "category_id":
//                                                                  "${widget.justMenus[index].oid}",
//                                                              "editing_fields":
//                                                                  {
//                                                                "name":
//                                                                    _categoryEditController
//                                                                        .text,
//                                                                "description":
//                                                                    _descriptionEditController
//                                                                        .text
//                                                              }
//                                                            },
//                                                            "edit_bar_category",
//                                                          );
//                                                        }
//                                                        Navigator.of(context)
//                                                            .pop(); // To close the dialog
//                                                      },
//                                                    ),
//                                                  ],
//                                                )
//                                              ],
//                                            ),
//                                          );
//                                        },
//                                      );
//                                    },
//                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: Text(
                                                "Delete ${widget.justMenus[index].name} Restaurant ?"),
                                            content: new Text(
                                              "This action will delete all Menu in this Restaurant",
                                              style: kSubTitleStyle,
                                            ),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              FlatButton(
                                                child: Text("Close"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: new Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  widget
                                                      .sendConfiguredDataToBackend(
                                                          {
                                                        "justmenu_id": widget
                                                            .justMenus[index]
                                                            .oid
                                                      },
                                                          "delete_justmenu");

                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPage(
                                    justMenu: widget.justMenus[index],
                                    sendConfiguredDataToBackend:
                                        widget.sendConfiguredDataToBackend,
                                  ),
                                ),
                              );
                            },
                          );
                        })
                    : Center(
                        child: Text('Restaurant list is empty'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
