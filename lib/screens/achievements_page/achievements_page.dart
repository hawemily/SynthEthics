import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement_card.dart';
import 'package:synthetics/theme/custom_colours.dart';

class AchievementsPage extends StatefulWidget {

  final Function onClose;

  const AchievementsPage({Key key, this.onClose}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5)
        )
      ),
      margin: EdgeInsets.all(30),
      child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: [
                    Center(
                      child : Text("Achievements",
                        style: TextStyle(
                          color: CustomColours.offWhite(),
                          fontWeight: FontWeight.bold
                        ),)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: CustomColours.offWhite(),
                          ),
                          onPressed: () => widget.onClose()
                        )
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: CustomColours.greenNavy(),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      color: CustomColours.offWhite(),
                      child: Column(
                        children: [
                          AchievementCard(progress: 0.4),
                          AchievementCard(progress: 0.2),
                          AchievementCard(progress: 1.0),
                          AchievementCard(progress: 0.4),
                          AchievementCard(progress: 0.2),
                          AchievementCard(progress: 1.0),
                          AchievementCard(progress: 0.4),
                          AchievementCard(progress: 0.2),
                          AchievementCard(progress: 1.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}
