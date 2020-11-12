import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/theme/custom_colours.dart';

class PreviewAchievementCard extends StatefulWidget {

  final double progress;
  final Function onClick;
  final bool oneTime;

  const PreviewAchievementCard({Key key, this.progress, this.onClick, this.oneTime})
      : super(key: key);

  @override
  _PreviewAchievementCardState createState() => _PreviewAchievementCardState();
}

class _PreviewAchievementCardState extends State<PreviewAchievementCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
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
              child: GestureDetector(
                child: Card(
                  color: CustomColours.negativeRed(),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: (widget.oneTime) ? Image.asset("lib/assets/medal.png") : Image.asset("lib/assets/medal2.png")),
                ),
                onTap: () => widget.onClick(new Achievement(type: (widget.oneTime) ? AchievementType.Unlock : AchievementType.Tiered)),
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}
