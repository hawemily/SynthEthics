import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/theme/custom_colours.dart';

class AchievementCard extends StatefulWidget {

  final double progress;

  const AchievementCard({Key key, this.progress}) : super(key: key);

  @override
  _AchievementCardState createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 5,
          color: CustomColours.greenNavy(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    color: CustomColours.negativeRed(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset("lib/assets/temp_medal.png")),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Achievement Type 1",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: CustomColours.offWhite(),
                          ),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: widget.progress,
                              valueColor: AlwaysStoppedAnimation<Color>(CustomColours.iconGreen()),
                              backgroundColor: CustomColours.offWhite(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
