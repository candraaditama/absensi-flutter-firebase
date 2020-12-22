import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geo_attendance_system/src/models/AttendaceList.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geofencing/geofencing.dart';
import 'package:location/location.dart';

String getDoubleDigit(String value) {
  if (value.length >= 2) return value;
  return "0" + value;
}

String getFormattedDate(DateTime day) {
  String formattedDate = getDoubleDigit(day.day.toString()) +
      "-" +
      getDoubleDigit(day.month.toString()) +
      "-" +
      getDoubleDigit(day.year.toString());
  return formattedDate;
}

String getFormattedTime(DateTime day) {
  String time = getDoubleDigit(day.hour.toString()) +
      ":" +
      getDoubleDigit(day.minute.toString()) +
      ":" +
      getDoubleDigit(day.second.toString());

  return time;
}

class AttendanceDatabase {
  static final _databaseReference = FirebaseDatabase.instance.reference();
  static final AttendanceDatabase _instance = AttendanceDatabase._internal();

  factory AttendanceDatabase() {
    return _instance;
  }

  AttendanceDatabase._internal();

  static Future<DataSnapshot> getAttendanceBasedOnUID(String uid) async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("Attendance").child(uid).once();
    return dataSnapshot;
  }

  static Future<dynamic> getAttendanceOfParticularDateBasedOnUID(
      String uid, DateTime dateTime) async {
    DataSnapshot snapshot = await getAttendanceBasedOnUID(uid);
    String formattedDate = getFormattedDate(dateTime);
    return snapshot.value == null ? null : snapshot.value[formattedDate];
  }

  static Future<Map<String, String>> getOfficeFromID() async {
    DataSnapshot dataSnapshot =
        await _databaseReference.child("location").once();
    Map<String, String> map = new Map();

    dataSnapshot.value.forEach((key, value) {
      map[key] = value["name"];
    });
    return map;
  }

  static Future<AttendanceList> getAttendanceListOfParticularDateBasedOnUID(
      String uid, DateTime dateTime) async {
    var snapshot = await getAttendanceOfParticularDateBasedOnUID(uid, dateTime);
    var mapOfOffice = await getOfficeFromID();
    //var lat = await getAttendanceListOfParticularDateBasedOnUID(uid, lat);
    AttendanceList attendanceList = AttendanceList.fromJson(
        snapshot, getFormattedDate(dateTime), mapOfOffice);
    attendanceList.dateTime = dateTime;

    return attendanceList != null ? attendanceList : [];
  }

  static Future markAttendance(
      //tambah location untuk disimpan di database
      String uid, DateTime dateTime, Office office, String markType, LocationData currentLocation) async {
    String time = getFormattedTime(dateTime);
    String date = getFormattedDate(dateTime);
    String lat = currentLocation.latitude.toString().replaceAll(".", ",");
    String long = currentLocation.longitude.toString().replaceAll(".", ",");
    var json = {
      "office": office.getKey,
      "time": time,
      "lat": lat,
      "long":long
    };
    String markChild = markType + "-" + time;
    return _databaseReference
        .reference()
        .child("Attendance")
        .child(uid)
        .child(date)
        .child(markChild)
        .update(json);
  }
}
