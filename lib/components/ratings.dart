import 'package:Upright_NG/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final int postCount;
  final WrapAlignment alignment;
  final bool showTitle;

  RatingWidget({
    this.postCount = 0,
    this.alignment = WrapAlignment.center,
    this.showTitle = true,
  });

  Widget _ratingContainer({int star = 0, String rank = ""}) {
    rank = rank == "" ? "Reporter" : "$rank Reporter";
    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(5, (idx) {
            return Icon(
              Icons.star,
              color: star > idx ? appYellow : appGrey,
              size: 20,
            );
          }),
        ),
        SizedBox(
          width: showTitle ? 10 : 0,
        ),
        showTitle
            ? AutoSizeText(
                rank,
                style: TextStyle(color: Colors.grey),
              )
            : SizedBox()
      ],
    );
  }

  Widget _ratingRoutine() {
    if (postCount >= 10 && postCount < 20) {
      return _ratingContainer(star: 1, rank: "Bronze");
    } else if (postCount >= 20 && postCount < 30) {
      return _ratingContainer(star: 2, rank: "Silver");
    } else if (postCount >= 30 && postCount < 40) {
      return _ratingContainer(star: 3, rank: "Gold");
    } else if (postCount >= 40 && postCount < 50) {
      return _ratingContainer(star: 4, rank: "Platinum");
    } else if (postCount >= 50) {
      return _ratingContainer(star: 5, rank: "Diamond");
    } else {
      return _ratingContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ratingRoutine();
  }
}
