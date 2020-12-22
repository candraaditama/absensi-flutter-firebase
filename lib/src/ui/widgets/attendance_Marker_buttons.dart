import 'package:flutter/material.dart';

Widget inOutButton(String buttonText, Color color, Function() callback) {
  return InkWell(
    child: Container(
      width: 110,
      height: 50,
      //color :Colors.transparent,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(color: color, width: 1),
      ),
      child: Material(
        child : Container(
          decoration: BoxDecoration(

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 0.75)
              )
            ],

              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
              colors: <Color>[Colors.lightBlue, Colors.cyan],
            ),
          ),
          child: InkWell(
            onTap: () {
              callback();
            },
            child: Center(
              child: Text(buttonText,
                  style: TextStyle(
                      color: color,
                      fontFamily: "Poppins-Regular",
                      fontSize: 16,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w900
                  )),
            ),
          ),
        ),

      ),
    ),
  );
}

Widget OutButton(String buttonText, Color color, Function() callback) {
  return InkWell(
    child: Container(
      width: 110,
      height: 50,
      //decoration: BoxDecoration(
      //  borderRadius: BorderRadius.circular(15.0),
        //border: Border.all(color: color, width: 4),
     // ),
      child: Material(
        child : Container(
          decoration: BoxDecoration(

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 0.75)
              )
            ],

            borderRadius: BorderRadius.all(Radius.circular(15)),
            gradient: LinearGradient(
              colors: <Color>[Colors.pinkAccent, Colors.redAccent],
            ),
          ),
          child: InkWell(
            onTap: () {
              callback();
            },
            child: Center(
              child: Text(buttonText,
                  style: TextStyle(
                      color: color,
                      fontFamily: "Poppins-Regular",
                      fontSize: 16,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w900
                  )),
            ),
          ),
        ),

      ),
    ),
  );
}