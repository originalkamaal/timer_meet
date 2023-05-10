import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timer_meet/models/meeting_model.dart';

class MeetController {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseDatabase _database = FirebaseDatabase.instance;
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<String> createMeeting(BuildContext context) async {
    DatabaseReference? refs = _database.ref("meetings").push();
    await refs.set({
      "startedAt": DateTime.now().millisecondsSinceEpoch,
      "host": _auth.currentUser!.displayName,
      "hostEmail": _auth.currentUser!.email,
      "hostPhotoURL": _auth.currentUser!.photoURL,
      "logs": [
        {
          "type": "userJoined",
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "about": _auth.currentUser!.email
        }
      ],
      "timers": [],
      "status": "ACTIVE"
    }).then((value) {
      joinMeeting(context: context, meet: refs.key!);
      return "";
    }).catchError((e) {
      return "";
    });
    return refs.key!;
  }

  Stream<DatabaseEvent> meetingById({required String meetingId}) {
    return _database.ref("meetings/${meetingId}").onValue;
  }

  Future<void> closeMeeting({required String meetingId}) async {
    var reference = await _database.ref("meetings/${meetingId}");
    await reference.child("status").set("ENDED");
    await reference.child("endedOn").set(DateTime.now().millisecondsSinceEpoch);
  }

  Stream<String> getTimerByStartTimestamp(int timeStamp) {
    return Stream.periodic(Duration(seconds: 1), (_) {
      return _activeSince(
          ((DateTime.now().millisecondsSinceEpoch - timeStamp) / 1000).floor());
    });
  }

  Stream<String> getTimerByStartTimestampMS(int timeStamp) {
    return Stream.periodic(Duration(seconds: 1), (_) {
      return _activeSince(
          ((DateTime.now().millisecondsSinceEpoch - timeStamp) / 1000).floor());
    });
  }

  String timeDifference(int from, int to) {
    return _activeSince(((to - from) / 1000).floor());
  }

  static Future<void> createTimer(String meetingId, int seconds) async {
    print(meetingId);
    DatabaseReference reference =
        await _database.ref("meetings/$meetingId/timers").push();
    await reference.set({
      "speakTime": seconds,
      "status": "PAUSED",
      "host": _auth.currentUser!.displayName,
      "hostEmail": _auth.currentUser!.email,
      "createdOn": DateTime.now().millisecondsSinceEpoch
    }).onError((error, stackTrace) => print(error));
  }

  static String _activeSince(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();
    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();
    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();
    String result = "$minuteLeft : $secondsLeft";
    return result;
  }

  Stream<DatabaseEvent> getAllMeeting() {
    return _database.ref("meetings").onValue;
  }

  pauseTimer(Meeting meeting) async {
    if (meeting.meetingId != null && meeting.latestTimer != null) {
      await _database
          .ref("meetings")
          .child(meeting.meetingId!)
          .child("timers")
          .child(meeting.latestTimer!.timerId!)
          .child("status")
          .set("PAUSED");
    }
  }

  resumeTimer(Meeting meeting) async {
    if (meeting.meetingId != null && meeting.latestTimer != null) {
      await _database
          .ref("meetings")
          .child(meeting.meetingId!)
          .child("timers")
          .child(meeting.latestTimer!.timerId!)
          .child("status")
          .set("ACTIVE");
    }
  }

  endTimer(Meeting meeting) async {
    if (meeting.meetingId != null && meeting.latestTimer != null) {
      await _database
          .ref("meetings")
          .child(meeting.meetingId!)
          .child("timers")
          .child(meeting.latestTimer!.timerId!)
          .child("status")
          .set("ENDED");
    }
  }

  static joinMeeting(
      {required BuildContext context, required String meet}) async {
    DatabaseReference reference =
        await _database.ref("meetings").child(meet).child("users").push();
    await reference.set({
      "uid": user!.uid,
      "username": user!.displayName,
      "email": user!.email,
      "profile": user!.photoURL,
      "joinedAt": DateTime.now().millisecondsSinceEpoch,
      "leftAt": 0
    }).then((value) {
      Navigator.of(context).pushNamed("/activeMeeting", arguments: meet);
    });
  }
}
