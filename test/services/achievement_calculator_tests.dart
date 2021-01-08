import 'package:flutter_test/flutter_test.dart';
import 'package:synthetics/services/achievements/achievement_calculator.dart';

void main() {
  group("tests", () {
    var tiers = [100, 200, 500, 750, 1000, 1500];
    group("Level Tests", () {

      test("Zero value returns level 0", () {
        var level = AchievementLevelCalculator.calculate(tiers, 0)["level"];
        expect(level, 0);
      });

      test("Value below first threshold returns level 0", () {
        var level = AchievementLevelCalculator.calculate(tiers, 0)["level"];
        expect(level, 0);
      });

      test("Value past a threshold returns that threshold's level", () {
        var level = AchievementLevelCalculator.calculate(tiers, 650)["level"];
        expect(level, 3);
      });

      test("Value at exact threshold returns level for tier", () {
        for (int i = 0; i < tiers.length; i++) {
          var level = AchievementLevelCalculator
              .calculate(tiers, tiers[i])["level"];
          expect(level, i + 1);
        }
      });

      test("Value past final threshold returns correct relative to excess"
          "amount", () {
        var level = AchievementLevelCalculator.calculate(tiers, 1900)["level"];
        expect(level, tiers.length);

        level = AchievementLevelCalculator.calculate(tiers, 2000)["level"];
        expect(level, tiers.length + 1);

        level = AchievementLevelCalculator.calculate(tiers, 2501)["level"];
        expect(level, tiers.length + 2);
      });
    });

    group("Previous Amount Tests", () {

      test("Previous amount at value 0 is 0", () {
        var previous = AchievementLevelCalculator
            .calculate(tiers, 0)["previousAmount"];
        expect(previous, 0);
      });

      test("Previous amount past each tier is tier amount", () {
        for (int i = 0; i < tiers.length; i++) {
          var previous = AchievementLevelCalculator
              .calculate(tiers, tiers[i])["previousAmount"];
          expect(previous, tiers[i]);
        }
      });

      test("Previous amount past tiered levels is correct", () {
        var previous = AchievementLevelCalculator
            .calculate(tiers, 1600)["previousAmount"];
        expect(previous, 1500);

        previous = AchievementLevelCalculator
            .calculate(tiers, 2000)["previousAmount"];
        expect(previous, 2000);

        previous = AchievementLevelCalculator
            .calculate(tiers, 2499)["previousAmount"];
        expect(previous, 2000);
      });
    });

    group("Target Amount Tests", () {

      test("Target amount at 0 is first tier amount", () {
        var target = AchievementLevelCalculator
            .calculate(tiers, 0)["targetAmount"];
        expect(target, tiers[0]);
      });

      test("Target to first tier is correct", () {
        var target = AchievementLevelCalculator
            .calculate(tiers, tiers[0] + 30)["targetAmount"];
        expect(target, tiers[1]);
      });

      test("Target amount per level is amount to next tier", () {
        for (int i = 0; i < tiers.length - 1; i++) {
          var target = AchievementLevelCalculator
              .calculate(tiers, tiers[i])["targetAmount"];
          expect(target, tiers[i + 1]);
        }
      });

      test("Target amount after highest tier is correct", () {
        var lastDiff = tiers[tiers.length - 1] - tiers[tiers.length - 2];
        for (int i = 0; i < 3; i++) {
          var target = AchievementLevelCalculator
              .calculate(tiers,
                tiers[tiers.length - 1] + i * lastDiff)["targetAmount"];
          expect(target, tiers[tiers.length - 1] + (i + 1) * lastDiff);
        }
      });
    });

    group("Progress Tests", () {
      test("Progress at 0 is 0", () {
        var progress = AchievementLevelCalculator
            .calculate(tiers, 0)["progress"];
        expect(progress, 0);
      });

      test("Progress to first tier is correct", () {
        var progress = AchievementLevelCalculator
            .calculate(tiers, 30)["progress"];
        expect(progress, 30);
      });

      test("Progress to next level is amount from previous tier", () {
        for (int i = 1; i < tiers.length; i++) {
          var progress = AchievementLevelCalculator
              .calculate(tiers, tiers[i] - 30)["progress"];
          expect(progress, tiers[i] - 30 - tiers[i - 1]);
        }
      });

      test("Progress after highest tier is correct", () {
        var lastDiff = tiers[tiers.length - 1] - tiers[tiers.length - 2];
        for (int i = 0; i < 3; i++) {
          var progress = AchievementLevelCalculator
              .calculate(tiers,
              tiers[tiers.length - 1] + i * lastDiff + 30)["progress"];
          expect(progress, 30);
        }
      });
    });
  });
}