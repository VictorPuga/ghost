import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingImage extends StatefulWidget {
  @override
  _LoadingImageState createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage>
    with TickerProviderStateMixin<LoadingImage> {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = [
      Colors.white,
      Color.fromRGBO(229, 229, 229, 0.8),
    ];
    return GradientAnimation(
      begin: LinearGradient(
        colors: colors,
        end: Alignment.center,
        tileMode: TileMode.mirror,
      ),
      end: LinearGradient(
        colors: colors.reversed.toList(),
        begin: Alignment.center,
        tileMode: TileMode.mirror,
      ),
      controller: _controller,
    );
  }
}

class GradientAnimation extends StatefulWidget {
  final LinearGradient begin;
  final LinearGradient end;
  final AnimationController controller;

  const GradientAnimation({
    Key key,
    @required this.controller,
    @required this.begin,
    @required this.end,
  }) : super(key: key);

  @override
  _GradientAnimationState createState() => _GradientAnimationState();
}

class _GradientAnimationState extends State<GradientAnimation> {
  Animation<LinearGradient> _animation;

  @override
  void initState() {
    _animation = LinearGradientTween(
      begin: widget.begin,
      end: widget.end,
    ).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: _animation.value,
          ),
        );
      },
    );
  }
}

class LinearGradientTween extends Tween<LinearGradient> {
  LinearGradientTween({
    LinearGradient begin,
    LinearGradient end,
  }) : super(begin: begin, end: end);

  @override
  LinearGradient lerp(double t) => LinearGradient.lerp(begin, end, t);
}
