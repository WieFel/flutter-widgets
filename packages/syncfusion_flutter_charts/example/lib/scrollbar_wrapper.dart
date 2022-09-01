import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class ScrollbarWrapper extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final Widget child;
  final bool _swipeToScroll;

  ScrollbarWrapper({
    Key? key,
    required this.child,
  })  : _swipeToScroll = false,
        super(key: key);

  ScrollbarWrapper.swipeToScroll({
    Key? key,
    required this.child,
  })  : _swipeToScroll = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return VsScrollbar(
      controller: _controller,
      isAlwaysShown: true,
      style: VsScrollbarStyle(
        color: Theme.of(context).colorScheme.secondary,
        thickness: 16,
      ),
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: _swipeToScroll ? null : const NeverScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}
