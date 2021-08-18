import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/constants.dart';
import '../utils/custom_color.dart';
import 'counter_badge.dart';

class SideMenuItem extends StatelessWidget {
  SideMenuItem(
      {required this.isActive,
      this.isHover = false,
      required this.itemCount,
      this.showBorder = true,
      required this.iconSrc,
      required this.title,
      required this.press});
  //const SideMenuItem({
  //  Key key,
  //  this.isActive,
  //  this.isHover = false,
  //  this.itemCount,
  //  this.showBorder = true,
  //  required this.iconSrc,
  //  required this.title,
  //  required this.press,
  //}) : super(key: key);

  final bool isActive, isHover, showBorder;
  final int itemCount;
  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            (isActive || isHover)
                ? WebsafeSvg.asset(
                    "assets/Icons/Angle right.svg",
                    width: 15,
                  )
                : SizedBox(width: 15),
            SizedBox(width: Constants.kDefaultPadding / 4),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 15, right: 5),
                decoration: showBorder
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFDFE2EF)),
                        ),
                      )
                    : null,
                child: Row(
                  children: [
                    WebsafeSvg.asset(
                      iconSrc,
                      height: 20,
                      color: (isActive || isHover)
                          ? CustomColors.kPrimaryColor
                          : CustomColors.kGrayColor,
                    ),
                    SizedBox(width: Constants.kDefaultPadding * 0.75),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: (isActive || isHover)
                                ? CustomColors.kTextColor
                                : CustomColors.kGrayColor,
                          ),
                    ),
                    Spacer(),
                    if (itemCount != null) CounterBadge(count: itemCount)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
