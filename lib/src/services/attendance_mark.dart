import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_attendance_system/src/models/office.dart';
import 'package:geo_attendance_system/src/ui/widgets/Info_dialog_box.dart';
import 'package:location/location.dart';

import 'current_date.dart';
import 'fetch_attendance.dart';
import 'geofence.dart';

String findLatestIn(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 2) == "in")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.last.toString().split("-")[1];
}

String findLatestOut(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 3) == "out")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.last.toString().split("-")[1];
}

String findFirstIn(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 2) == "in")
      .toList();

  if (finalList.length == 0) return "";
  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.first.toString().split("-")[1];
}

String findFirstOut(listOfAttendanceIterable) {
  List finalList = listOfAttendanceIterable
      .where((attendance) => attendance.toString().substring(0, 3) == "out")
      .toList();

  if (finalList.length == 0) return "";

  finalList.sort((a, b) {
    String time1 = a.toString().split("-")[1];
    String time2 = b.toString().split("-")[1];
    return time1.compareTo(time2);
  });

  return finalList.first.toString().split("-")[1];
}



bool checkSuccessiveIn(listOfAttendanceIterable) {
  if (listOfAttendanceIterable.length > 0) {
    String lastOut = findLatestOut(listOfAttendanceIterable);
    String lastIn = findLatestIn(listOfAttendanceIterable);

    if (lastIn == "" || (lastOut != "" && lastIn.compareTo(lastOut) <= 0))
      return true;
    else
      return false;
  }
  return true;
}

bool checkSuccessiveOut(listOfAttendanceIterable) {
  if (listOfAttendanceIterable.length > 0) {
    String lastOut = findLatestOut(listOfAttendanceIterable);
    String lastIn = findLatestIn(listOfAttendanceIterable);

    if (lastOut == "" || (lastIn != "" && lastOut.compareTo(lastIn) <= 0))
      return true;
    else
      return false;
  }
  return true;
}

//markIn Original
/*
void markInAttendance(BuildContext context, Office office,
    LocationData currentPosition, FirebaseUser user) async {
  Future.delayed(Duration(seconds: 1), () {
    DateTime dateToday = getTodayDate();
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
            user.uid, dateToday)
        .then((snapshot) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      bool isFeasible = true;
      String errorMessage = "";
      if (snapshot != null) {
        var listOfAttendanceIterable = snapshot.keys;
        if (listOfAttendanceIterable.length > 0 &&
            !checkSuccessiveIn(listOfAttendanceIterable)) {
          isFeasible = false;
          errorMessage = "Gagal! Pastikan Anda sudah absen pulang, atau restart aplikasi";
        }
      }

      if (isFeasible &&
          (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
              GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
        AttendanceDatabase.markAttendance(user.uid, dateToday, office, "in", currentPosition)
            .then((_) {
          showDialogTemplate(
              context,
              "Informasi Absensi",
              "Berhasil \nStatus: ${GeoFenceClass.geofenceState}",
              "assets/gif/tick.gif",
              Color.fromRGBO(51, 205, 187, 1.0),
              "Semangat..!");
        });
      } else {
        if (isFeasible) errorMessage = "Diluar jangkauan lokasi yang ditentukan!"+ currentPosition.latitude.toString();
        showDialogTemplate(
            context,
            "Informasi Absensi",
            "$errorMessage\nStatus: ${GeoFenceClass.geofenceState}",
            "assets/gif/close.gif",
            Color.fromRGBO(200, 71, 108, 1.0),
            "Oops!");
      }
    });
  });
}
*/

void markInAttendance(BuildContext context, Office office,
    LocationData currentPosition, FirebaseUser user) async {
  Future.delayed(Duration(seconds: 1), () {
    DateTime dateToday = getTodayDate();
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
        user.uid, dateToday)
        .then((snapshot) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
     // bool isFeasible = true;
     // String errorMessage = "";
      /*
      if (snapshot != null) {
        var listOfAttendanceIterable = snapshot.keys;
        //mematikan fungsi harus pulang sebelum check-in kembali di hari yang sama
        if (listOfAttendanceIterable.length > 0 &&
            !checkSuccessiveIn(listOfAttendanceIterable)) {
          isFeasible = false;
          errorMessage = "Gagal! Pastikan Anda sudah absen pulang, atau restart aplikasi";
        }
      } */

      //if (
       //   (GeoFenceClass.geofenceState == "GeofenceEvent.enter")) {
        AttendanceDatabase.markAttendance(user.uid, dateToday, office, "in", currentPosition)
            .then((_) {
          showDialogTemplate(
              context,
              "Informasi Absensi",
              //"Informasi absensi berhasil disimpan \nStatus: ${GeoFenceClass.geofenceState}",
              "Informasi absensi berhasil disimpan",
              "assets/gif/tick.gif",
              Color.fromRGBO(51, 205, 187, 1.0),
              "Semangat..!");
        });
     /* } else {
        //if (isFeasible) errorMessage = "Diluar jangkauan lokasi yang ditentukan!"+ currentPosition.latitude.toString();
        showDialogTemplate(
            context,
            "Informasi Absensi",
            "errorMessage\nStatus: ${GeoFenceClass.geofenceState}",
            "assets/gif/close.gif",
            Color.fromRGBO(200, 71, 108, 1.0),
            "Oops!");
      } */
    });
  });
}

void markOutAttendance(BuildContext context, Office office,
    LocationData currentPosition, FirebaseUser user) async {
  Future.delayed(Duration(seconds: 1), () {
    DateTime dateToday = getTodayDate();
    AttendanceDatabase.getAttendanceOfParticularDateBasedOnUID(
            user.uid, dateToday)
        .then((snapshot) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      bool isFeasible = true;
      String errorMessage = "";

      /* Mematikan fungsi  cek absen masuk
      if (snapshot != null) {
        var listOfAttendanceIterable = snapshot.keys;
        if (listOfAttendanceIterable.length > 0 &&
            !checkSuccessiveOut(listOfAttendanceIterable)) {
          isFeasible = false;
          errorMessage = "Gagal Absen pulang !";
        } else if (listOfAttendanceIterable.length == 0) {
          isFeasible = false;
          errorMessage = "Tidak ditemukan absensi masuk!";
        }
      } else {
        isFeasible = false;
        errorMessage = "Tidak ditemukan absensi masuk!";
      } */

      /* Fungsi geofencing dimatikan
      if (isFeasible &&
          (GeoFenceClass.geofenceState == "GeofenceEvent.dwell" ||
              GeoFenceClass.geofenceState == "GeofenceEvent.enter")) { */
        AttendanceDatabase.markAttendance(user.uid, dateToday, office, "out", currentPosition)
            .then((_) {
          showDialogTemplate(
              context,
              "Informasi Absensi",
              //"Berhasil \nStatus: ${GeoFenceClass.geofenceState}",
              "Absensi pulang berhasil disimpan",
              "assets/gif/tick.gif",
              Color.fromRGBO(51, 205, 187, 1.0),
              "Terima kasih");
        });

     /* fungsi batasan likasi pulang dimatikan
      } else {

        if (isFeasible) errorMessage = "Diluar jangkauan lokasi yang ditentukan!";
        showDialogTemplate(
            context,
            "Informasi Absensi",
            "$errorMessage\nStatus: ${GeoFenceClass.geofenceState}",
            "assets/gif/close.gif",
            Color.fromRGBO(200, 71, 108, 1.0),
            "Oops!");
      } */
    });
  });
}
