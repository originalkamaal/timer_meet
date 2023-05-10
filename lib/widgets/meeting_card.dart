import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_meet/controllers/meet_controller.dart';

import '../models/meeting_model.dart';

Widget meetingCard({required Meeting? meeting, required context}) {
  MeetController().getAllMeeting();
  return Container(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      children: [
        Visibility(
          visible: meeting!.host == "You",
          child: CircleAvatar(
              minRadius: 30,
              backgroundImage: NetworkImage(meeting.hostPhotoUrl!)),
        ),
        Expanded(
          child: Card(
            margin: meeting.host == "You"
                ? const EdgeInsets.only(left: 10)
                : const EdgeInsets.only(right: 10),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meeting.host ?? "Someone",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.yMMMEd()
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  meeting.startedAt!))
                              .toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700.withOpacity(0.7)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.jm()
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      meeting.startedAt!))
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            meeting.endedOn == null
                                ? const Text("Live")
                                : Text(
                                    "Duration: ${MeetController().timeDifference(meeting.startedAt!, meeting.endedOn!).toString()}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700
                                            .withOpacity(0.7)),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: meeting.status == "ACTIVE"
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          meeting.status == "ACTIVE" ? "JOIN  " : "MORE  ",
                          style: TextStyle(
                              color: Colors.deepPurple.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          if (meeting.status == "ACTIVE") {
                            await MeetController.joinMeeting(
                                context: context, meet: meeting.meetingId!);
                          } else {
                            Navigator.of(context).pushNamed("/meetingDetail");
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: meeting.host != "You",
          child: CircleAvatar(
              minRadius: 30,
              backgroundImage: NetworkImage(meeting.hostPhotoUrl!)),
        ),
      ],
    ),
  );
}
