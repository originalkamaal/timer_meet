import 'package:flutter/material.dart';
import 'package:timer_meet/controllers/auth_controller.dart';
import 'package:timer_meet/controllers/meet_controller.dart';
import 'package:timer_meet/models/meeting_model.dart';
import 'package:timer_meet/widgets/confirmation_dialog.dart';
import 'package:timer_meet/widgets/meeting_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          "assets/images/Logo.png",
          width: 100,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAlertDialog(context, "Start Meeting", "Are you sure?", () {
                Navigator.pop(context);
              }, () async {
                Navigator.pop(context);
                String reference = await MeetController.createMeeting(context);
                // if (reference != "") {
                //   Navigator.of(context)
                //       .pushNamed("/activeMeeting", arguments: reference);
                // }
              });
            },
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                await Authentication.logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: MeetController().getAllMeeting(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            List<Meeting> meetingList = snapShot.data!.snapshot.children.map(
              (e) {
                return Meeting()
                    .fromJSON(e.value as Map<Object?, Object?>, e.key!);
              },
            ).toList();
            meetingList.sort(
              (a, b) {
                return b.startedAt!.compareTo(a.startedAt!);
              },
            );
            return ListView.builder(
              itemCount: meetingList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child:
                    meetingCard(meeting: meetingList[index], context: context),
              ),
            );
          } else {
            return Text("Loading..");
          }
        },
      ),
    );
  }
}
