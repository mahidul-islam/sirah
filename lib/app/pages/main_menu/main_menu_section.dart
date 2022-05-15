import 'package:flutter/material.dart';
import "plus_decoration.dart";

typedef SelectItemCallback = Function();

class MenuSection extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final Color accentColor;
  final SelectItemCallback selectItem;
  final List<String> menuOptions;

  const MenuSection(this.title, this.backgroundColor, this.accentColor,
      this.menuOptions, this.selectItem,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SectionState();
}

class _SectionState extends State<MenuSection>
    with SingleTickerProviderStateMixin {
  Animation<double>? expandAnimation;
  late AnimationController expandController;

  late AnimationController _controller;
  static final Animatable<double> _sizeTween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  Animation<double>? _sizeAnimation;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sizeAnimation = _controller.drive(_sizeTween);
  }

  @override
  dispose() {
    expandController.dispose();
    super.dispose();
  }

  _onExpand() {
    switch (_sizeAnimation!.status) {
      case AnimationStatus.completed:
        //expandController.reverse();
        _controller.reverse();
        break;
      case AnimationStatus.dismissed:
        //expandController.forward();
        _controller.forward();
        break;
      case AnimationStatus.reverse:
      case AnimationStatus.forward:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onExpand,
      child: Container(
        //height: _height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: widget.backgroundColor),
        child: Column(
          children: [
            SizedBox(
              height: 150.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                            height: 20.0,
                            width: 20.0,
                            margin: const EdgeInsets.all(18.0),
                            decoration: PlusDecoration(
                                widget.accentColor, _sizeAnimation!.value)),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "RobotoMedium",
                            color: widget.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              axisAlignment: 0.0,
              axis: Axis.vertical,
              sizeFactor: _sizeAnimation!,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 56.0, right: 20.0, top: 10.0),
                child: Column(
                  children: widget.menuOptions.map(
                    (label) {
                      return GestureDetector(
                        onTap: () =>
                            //print("GO TO MENU OPTION: $label");
                            widget.selectItem(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                      color: widget.accentColor,
                                      fontSize: 20.0,
                                      fontFamily: "RobotMedium"),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/right_arrow.png",
                                color: widget.accentColor,
                                height: 22.0,
                                width: 22.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
