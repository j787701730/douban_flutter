import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final ratingValue;

  Rating(this.ratingValue);

  _star() {
//    print('$ratingValue = ${ratingValue ~/ 1} = ${ratingValue % 1}');
    return Row(
      children: <Widget>[
        Row(
          children: List(ratingValue ~/ 2).map<Widget>((item) {
            return Image.asset(
              'images/rating_star_xsmall_on.webp',
              width: 20,
            );
          }).toList(),
        ),
        ratingValue % 1 > 0.099
            ? Image.asset(
                'images/rating_star_xsmall_half.webp',
                width: 20,
              )
            : Image.asset(
                'images/rating_star_xsmall_off.webp',
                width: 20,
              ),
        Row(
          children: List((9.9 - ratingValue) ~/ 2).map<Widget>((item) {
            return Image.asset(
              'images/rating_star_xsmall_off.webp',
              width: 20,
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _star(),
        Text(
          ' $ratingValue',
          style: TextStyle(fontSize: 20, color: Color(0xff808080)),
        )
      ],
    );
  }
}
