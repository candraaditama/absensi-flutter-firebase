import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:geo_attendance_system/src/ui/constants/colors.dart';
// import 'package:firebase_core/firebase_core.dart'; not nessecary

class InfoKompetitor extends StatefulWidget {
  @override
  InfoKompetitorState createState() => InfoKompetitorState();
}

class InfoKompetitorState extends State<InfoKompetitor> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;
  //FirebaseUser user;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = Item("", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;


    ///Setelah menulis di FirebaseDatabase(), langsung mengambil instance.
    itemRef = database.reference().child('kompetitor');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event ) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Promo Kompetitor'),
      ),
      resizeToAvoidBottomPadding: false,
      body:
      /*Container(
        //color: dashBoardColor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [splashScreenColorBottom, splashScreenColorTop],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,),
        ), */
      Column(
        children: <Widget>[
          SizedBox(height: 10),
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.title,),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => item.title = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                          labelText: "Judul",
                         // fillColor: Color(0xFFF),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 6,
                        initialValue: '',
                        onSaved: (val) => item.body = val,
                        validator: (val) => val == "" ? val : null,
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          // fillColor: Color(0xFFF),
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                    /// tombol hanya berupa icon
                    /*
                    IconButton(
                      icon: Icon(Icons.send,color: Colors.lightBlue,),
                      onPressed: () {
                        handleSubmit();
                      },
                    ),
                    */
                    /// Tombol kirim
                    RaisedButton.icon(
                      onPressed: () {
                        handleSubmit();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      label: Text(
                        'KIRIM',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      textColor: Colors.white,
                      splashColor: Colors.red,
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            child: FirebaseAnimatedList(
              reverse: true,
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new ListTile(
                    //leading: Icon(Icons.message),
                    //title: Text(items[index].title),
                    //subtitle: Text(items[index].body),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white24)),
                      ),
                      child: Icon(Icons.message, color: Colors.lightBlue),
                    ),
                    title: Text(
                      items[index].title,
                      style: TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.more_vert, color: Colors.lightBlueAccent),
                        Text(items[index].body,
                            style: TextStyle(color: Colors.black45))
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.lightBlue, size: 30.0));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  String key;
  String title;
  String body;
  //var user  = FirebaseUser user;

  Item( this.title, this.body);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key =  snapshot.key,
        title = snapshot.value["title"],
        body = snapshot.value["body"];

  toJson() {
    return {
      "title": title,
      "body": body,
    };
  }
}
