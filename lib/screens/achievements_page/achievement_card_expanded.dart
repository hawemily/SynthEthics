import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/theme/custom_colours.dart';

class ExpandedAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final Function onClose;

  const ExpandedAchievementCard({Key key,
    this.achievement, this.onClose}) : super(key: key);

  @override
  _ExpandedAchievementCardState createState() => _ExpandedAchievementCardState();
}

class _ExpandedAchievementCardState extends State<ExpandedAchievementCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Stack(
                    children: [
                      Center(
                          child : Text(widget.achievement.name.toUpperCase(),
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
                  child: Column(
                    children: [
                      Image.asset("lib/assets/temp_medal.png"),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: widget.achievement.progressToTarget /
                                (widget.achievement.nextTarget -
                                 widget.achievement.previousTarget),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColours.iconGreen()),
                            backgroundColor: CustomColours.offWhite(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(widget.achievement.previousTarget.toString()),
                          Text((widget.achievement.progressToTarget +
                              widget.achievement.previousTarget).toString() +
                              "/" + widget.achievement.nextTarget.toString()),
                          Text(widget.achievement.nextTarget.toString())
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
