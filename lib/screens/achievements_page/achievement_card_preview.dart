import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/achievements_page/achievement.dart';
import 'package:synthetics/services/achievements/achievement_images.dart';
import 'package:synthetics/theme/custom_colours.dart';

class PreviewAchievementCard extends StatefulWidget {
  final Achievement achievement;
  final Function onClick;

  const PreviewAchievementCard({Key key, this.achievement, this.onClick})
      : super(key: key);

  @override
  _PreviewAchievementCardState createState() => _PreviewAchievementCardState();
}

class _PreviewAchievementCardState extends State<PreviewAchievementCard> {
  @override
  Widget build(BuildContext context) {
    bool toGreyOut = !widget.achievement.achieved &&
        widget.achievement.type == AchievementType.Unlock;
    return Container(
      foregroundDecoration: toGreyOut
          ? BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
            )
          : null,
      child: Card(
        elevation: 5,
        color: CustomColours.greenNavy(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Card(
                    color: CustomColours.greenNavy(),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child:
                            (widget.achievement.type == AchievementType.Unlock)
                                ? AchievementImages.retrieveOneTimeImage(
                                    widget.achievement.id)
                                : AchievementImages.retrieveLevelImage(
                                    widget.achievement.id,
                                    widget.achievement.level)),
                  ),
                  onTap: () => widget.onClick(widget.achievement),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
