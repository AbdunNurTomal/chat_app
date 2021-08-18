import 'package:flutter/material.dart';

import '../component/extensions.dart';
import '../utils/custom_color.dart';

class CounterBadge extends StatelessWidget {
  CounterBadge({required this.count});
  //const CounterBadge({
  //  Key key,
  //  @required this.count,
  //}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: CustomColors.kBadgeColor,
          borderRadius: BorderRadius.circular(9)),
      child: Text(
        count.toString(),
        style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
      ),
    ).addNeumorphism(
      offset: Offset(4, 4),
      borderRadius: 9,
      blurRadius: 4,
      topShadowColor: Colors.white,
      bottomShadowColor: Color(0xFF30384D).withOpacity(0.3),
    );
  }
}
