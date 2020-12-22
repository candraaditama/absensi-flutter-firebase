import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/attendance_recorder.dart';
import '../pages/attendance_summary.dart';
import '../pages/leave_application.dart';
//import '../pages/leave_status.dart';
import '../pages/info_kompetitor.dart';
import '../pages/upload_photo.dart';

void attendanceSummaryCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (context) => AttendanceSummary(
              title: "Catatan Kehadiran",
              user: user,
            )),
  );
}

void attendanceRecorderCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => AttendanceRecorderWidget(user: user)));
}

void leaveApplicationCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => UploadPhoto( 
                //title: "Leave Application",
                //user: user,
              )));
}

void leaveStatusCallback(BuildContext context, FirebaseUser user) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => InfoKompetitor(
                //title: "Leave Status",
                //user: user,
              )));
}

List<List> infoAboutTiles = [
  [
    "assets/icons/attendance_recorder.png",
    "Absensi",
    "Tandai Absensi",
    attendanceRecorderCallback
  ],
  [
    "assets/icons/attendance_summary.png",
    "Data Absensi",
    "Data absensi",
    attendanceSummaryCallback
  ],
  [
    "assets/icons/leave_application.png",
    "Unggah Foto",
    "Foto display",
    leaveApplicationCallback
  ],
  [
    "assets/icons/leave_status.png",
    "Kompetitor",
    "Promosi kompetitor",
    leaveStatusCallback
  ],
];
