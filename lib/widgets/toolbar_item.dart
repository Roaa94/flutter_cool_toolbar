import 'package:cool_tool_bar/constants.dart';
import 'package:cool_tool_bar/models/toolbar_item_data.dart';
import 'package:flutter/material.dart';

class ToolbarItem extends StatelessWidget {
  const ToolbarItem(
    this.toolbarItem, {
    required this.height,
    required this.scrollScale,
    this.isLongPressed = false,
    this.gutter = 10,
    Key? key,
  }) : super(key: key);

  final ToolbarItemData toolbarItem;
  final double height;
  final double scrollScale;
  final bool isLongPressed;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: height + gutter,
        child: Stack(
          children: [
            AnimatedScale(
              scale: scrollScale,
              duration: Constants.scrollScaleAnimationDuration,
              curve: Constants.scrollScaleAnimationCurve,
              child: AnimatedContainer(
                duration: Constants.longPressAnimationDuration,
                curve: Constants.longPressAnimationCurve,
                height: height + (isLongPressed ? 10 : 0),
                width: isLongPressed ? Constants.toolbarWidth * 2 : height,
                decoration: BoxDecoration(
                  color: toolbarItem.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  bottom: gutter,
                  left: isLongPressed ? Constants.itemsOffset : 0,
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedPadding(
                duration: Constants.longPressAnimationDuration,
                curve: Constants.longPressAnimationCurve,
                padding: EdgeInsets.only(
                  bottom: gutter,
                  left: 12 + (isLongPressed ? Constants.itemsOffset : 0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      scale: scrollScale,
                      duration: Constants.scrollScaleAnimationDuration,
                      curve: Constants.scrollScaleAnimationCurve,
                      child: Icon(
                        toolbarItem.icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: Constants.longPressAnimationDuration,
                        curve: Constants.longPressAnimationCurve,
                        opacity: isLongPressed ? 1 : 0,
                        child: Text(
                          toolbarItem.title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
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
