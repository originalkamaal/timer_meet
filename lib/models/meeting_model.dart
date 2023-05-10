import 'package:firebase_auth/firebase_auth.dart';

class Meeting {
  String? meetingId;
  String? host;
  String? hostEmail;
  String? hostPhotoUrl;
  int? endedOn;
  List<Participants>? participants;

  int? startedAt;
  String? status;
  bool isTimerActive = false;
  List<MeetingLog>? meetingLog;
  MeetingTimer? latestTimer;
  // Map<Object?, Object?>? timers;
  List<MeetingTimer>? timers;
  Meeting(
      {this.meetingId,
      this.host,
      this.startedAt,
      this.status,
      this.hostEmail,
      this.hostPhotoUrl,
      this.latestTimer,
      this.timers,
      this.participants,
      this.endedOn,
      this.meetingLog});

  Meeting fromJSON(Map<Object?, Object?> meetingMap, String meetingId) {
    Meeting meeting = Meeting(
        participants: meetingMap.containsKey('users')
            ? Participants.fromJSON(
                meetingMap['users'] as Map<Object?, Object?>)
            : null,
        meetingId: meetingId,
        host: (meetingMap['hostEmail'] as String) ==
                FirebaseAuth.instance.currentUser!.email
            ? "You"
            : meetingMap['host'] as String,
        hostEmail: (meetingMap['hostEmail'] as String),
        hostPhotoUrl: meetingMap['hostPhotoURL'] as String,
        startedAt: meetingMap['startedAt'] as int,
        status: meetingMap['status'] as String,
        meetingLog: MeetingLog.fromJSON(meetingMap['logs'] as List<dynamic>),
        timers: meetingMap['timers'] != null
            ? MeetingTimer()
                .fromJSON(meetingMap['timers'] as Map<Object?, Object?>)
            : null,
        latestTimer: meetingMap['timers'] != null
            ? recentTimer(meetingMap['timers'] as Map<Object?, Object?>)
            : null,
        endedOn: meetingMap['endedOn'] != null
            ? meetingMap['endedOn'] as int
            : null);

    return meeting;
  }

  MeetingTimer? recentTimer(Map<Object?, Object?> map) {
    List<MeetingTimer> timers = [];
    map.forEach((key, value) {
      value = (value as Map<Object?, Object?>);
      timers.add(MeetingTimer(
          status: value['status'] as String,
          timerId: key as String,
          speakTime: value['speakTime'] as int,
          createdOn: value['createdOn'] as int,
          host: value['host'] as String,
          hostEmail: value['hostEmail'] as String,
          endedOn: value['endedOn'] != null ? value['endedOn'] as int : null));
    });
    timers.sort((a, b) {
      return a.createdOn!.compareTo(b.createdOn!);
    });
    return timers[(timers.length) - 1];
  }
}

class MeetingLog {
  String? about;
  String? timeStamp;
  String? type;

  MeetingLog({this.about, this.timeStamp, this.type});

  static List<MeetingLog> fromJSON(List<dynamic> meetingLogs) {
    List<MeetingLog> logs = [];
    meetingLogs.map(
      (e) {
        logs.add(MeetingLog(
            about: e['about'], timeStamp: e['timeStamp'], type: e['type']));
      },
    ).toList();

    return logs;
  }
}

class MeetingLogType {
  String userJoined = "UserJoined";
  String userLeft = "UserLeft";
  String meetingStarted = "MeetingStarted";
  String meetingEnded = "MeetingEnded";
  String timerStarted = "TimerStarted";
  String timerEnded = "TimerEnded";
  String timerPaused = "TimerPaused";
  String userStartedSpeaking = "UserStartedSpeaking";
  String userEndedSpeaking = "UserEndedSpeaking";
}

class Participants {
  String name;
  String email;
  String uid;
  int joinedAt;
  int? leftAt;
  String photoURL;
  Participants(
      {required this.name,
      required this.email,
      required this.uid,
      required this.joinedAt,
      this.leftAt,
      required this.photoURL});

  static List<Participants> fromJSON(Map<Object?, Object?> participantsMap) {
    List<Participants> participants = [];
    participantsMap.forEach((key, value) {
      value = value as Map<Object?, Object?>;

      participants.add(Participants(
          name: value['username'] as String,
          email: value['email'] as String,
          uid: value['uid'] as String,
          joinedAt: value['joinedAt'] as int,
          photoURL: value['profile'] as String,
          leftAt: value['leftAt'] as int));
    });
    // participantsMap.map(
    //   // (e) {
    //   //   participants.add(Participants(
    //   //       name: e['email'],
    //   //       email: e['timeStamp'],
    //   //       uid: e['uid'],
    //   //       joinedAt: e['joinedAt'],
    //   //       leftAt: e['leftAt'],
    //   //       photoURL: e['photoUrl']));
    //   // },
    // ).toList();

    return participants;
  }
}

class MeetingTimer {
  String? timerId;
  String? status;
  int? speakTime;
  String? host;
  String? hostEmail;
  int? createdOn;
  int? endedOn;
  List<MeetingTimerActivity?>? activities;

  MeetingTimer(
      {this.speakTime,
      this.timerId,
      this.host,
      this.status,
      this.hostEmail,
      this.createdOn,
      this.endedOn});

  List<MeetingTimer> fromJSON(Map<Object?, Object?> map) {
    List<MeetingTimer> timers = [];
    map.forEach((key, value) {
      value = (value as Map<Object?, Object?>);
      timers.add(MeetingTimer(
          status: value['status'] as String,
          timerId: key as String,
          speakTime: value['speakTime'] as int,
          createdOn: value['createdOn'] as int,
          host: value['host'] as String,
          hostEmail: value['hostEmail'] as String,
          endedOn: value['endedOn'] != null ? value['endedOn'] as int : null));
    });
    return timers;
  }
}

class MeetingTimerActivity {
  String? status;
  int? timeStamp;
  List<String>? previousUser;
  String? currentUser;
  String? nextUser;
}
