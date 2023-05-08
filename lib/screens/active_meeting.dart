import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timer_meet/controllers/meet_controller.dart';
import 'package:timer_meet/models/meeting_model.dart';
import 'package:timer_meet/widgets/error_text.dart';
import 'package:timer_meet/widgets/start_timer_dialog.dart';

class ActiveMeeting extends StatefulWidget {
  final String referance;
  const ActiveMeeting({super.key, required this.referance});

  @override
  State<ActiveMeeting> createState() => _ActiveMeetingState();
}

class _ActiveMeetingState extends State<ActiveMeeting> {
  String seconds = "";
  bool amIHost = false;
  String logMessages = "You have joined.";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MeetController().meetingById(meetingId: widget.referance),
      builder: (context, event) {
        if (event.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (event.hasData) {
          print(event.data!.snapshot.value);
          Meeting meeting = Meeting().fromJSON(
              (event.data!.snapshot.value as Map<Object?, Object?>),
              widget.referance);

          if (meeting.status != "ACTIVE") {
            return const Scaffold(
              body: Center(
                child: Text("Meeting ended by host.."),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurple.shade900,
              elevation: 0,
              centerTitle: true,
              title: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: StreamBuilder(
                  stream: MeetController()
                      .getTimerByStartTimestamp(meeting.startedAt!),
                  builder: (context, stream) {
                    if (stream.hasData) {
                      return Text(
                        stream.data!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    } else {
                      return const Text("00 : 00 : 00");
                    }
                  },
                ),
              ),
              actions: meeting.host! == "You"
                  ? [timerActions(context, meeting)]
                  : null,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.red,
              splashColor: Colors.deepPurple.shade900,
              child: const Icon(Icons.call_end_rounded),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Column(children: [
              Container(
                padding: meeting.host! == "You"
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          meeting.host!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            " ${meeting.host! == "You" ? "are" : "is"} hosting.."),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        await MeetController().endTimer(meeting);
                        await MeetController()
                            .closeMeeting(meetingId: widget.referance);
                      },
                      child: const Text("End Meeting"),
                    )
                  ],
                ),
              ),
              meeting.latestTimer != null &&
                      meeting.latestTimer!.status != 'ENDED'
                  ? Container(
                      width: double.infinity,
                      color: Colors.deepPurple.shade50,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: meeting.latestTimer!.status ==
                                              "PAUSED"
                                          ? Colors.red.shade500
                                          : Colors.red.shade900.withAlpha(50),
                                      boxShadow: meeting.latestTimer!.status ==
                                              "PAUSED"
                                          ? [
                                              BoxShadow(
                                                  blurRadius: 15,
                                                  color: Colors.red.shade500)
                                            ]
                                          : [],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: meeting.latestTimer!.status ==
                                              "ACTIVE"
                                          ? Colors.green.shade500
                                          : Colors.green.shade900.withAlpha(50),
                                      boxShadow: meeting.latestTimer!.status ==
                                              "ACTIVE"
                                          ? [
                                              BoxShadow(
                                                  blurRadius: 15,
                                                  color: Colors.green.shade500)
                                            ]
                                          : [],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      )),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 25,
                                      color: Colors.deepPurple.shade100)
                                ],
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Center(
                                    child: StreamBuilder(
                                        stream: MeetController()
                                            .getTimerByStartTimestampMS(meeting
                                                    .latestTimer!.createdOn! +
                                                (meeting.latestTimer!
                                                        .speakTime! *
                                                    1000)),
                                        builder: (context, timerSnap) {
                                          if (timerSnap.hasData) {
                                            return timer(timerSnap.data!);
                                          } else {
                                            return const Text(
                                              "",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          }
                                        }),
                                  ),
                                  const Center(
                                    child: Text(
                                      "User One",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppings'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ]),
                    )
                  : Container()
              // Container(
              //   padding: EdgeInsets.only(left: 10),
              //   height: 20,
              //   child: AnimatedTextKit(
              //     animatedTexts: [
              //       RotateAnimatedText(logMessages,
              //           alignment: Alignment.centerLeft),
              //     ],
              //     isRepeatingAnimation: true,
              //   ),
              // )
            ]),
          );
        }
        return Scaffold(
          body: Center(
            child: errorText("Something Went Wrong..."),
          ),
        );
      },
    );
  }

  Widget timerActions(BuildContext context, Meeting meeting) {
    if (meeting.latestTimer == null) {
      return IconButton(
        onPressed: () {
          showInformationDialog(
            context: context,
            onChange: (value) {
              setState(() {
                seconds = value;
              });
            },
            title: "Start Timer",
            onTap: () async {
              print(seconds);
              if (seconds != "") {
                await MeetController.createTimer(
                  widget.referance,
                  int.parse(seconds),
                );
              } else {}
            },
          );
        },
        icon: const Icon(Icons.timer),
      );
    }
    String status = meeting.latestTimer!.status!;
    if (status == "ACTIVE") {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              MeetController().pauseTimer(meeting);
            },
            icon: Icon(Icons.pause),
          ),
          IconButton(
            onPressed: () {
              MeetController().endTimer(meeting);
            },
            icon: Icon(Icons.stop),
          ),
        ],
      );
    }
    if (status == "PAUSED") {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              MeetController().resumeTimer(meeting);
            },
            icon: Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              MeetController().endTimer(meeting);
            },
            icon: Icon(Icons.stop),
          ),
        ],
      );
    }

    return IconButton(
      onPressed: () {
        showInformationDialog(
          context: context,
          onChange: (value) {
            setState(() {
              seconds = value;
            });
          },
          title: "Start Timer",
          onTap: () async {
            print(seconds);
            if (seconds != "") {
              await MeetController.createTimer(
                widget.referance,
                int.parse(seconds),
              );
            } else {}
          },
        );
      },
      icon: const Icon(Icons.timer),
    );
  }

  Text timer(String time) {
    return Text(
      time,
      style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
          color: Colors.deepPurple.shade900),
    );
  }
}
