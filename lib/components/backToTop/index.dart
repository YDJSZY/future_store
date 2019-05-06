import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackToTop extends StatefulWidget {
  ScrollController scrollController;
  double offset = 500;

  BackToTop(this.scrollController, {double offset = 500}) {
    this.offset = offset;
  }

  @override
  State<StatefulWidget> createState() {
    return _BackToTop();
  }
}

class _BackToTop extends State<BackToTop> {
  ScrollController scrollController;
  bool showToTopBtn = false;
  bool isUnMounted = false;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController;
    listenScroll();
  }

  listenScroll() {
    var _showToTopBtn = false;
    scrollController.addListener(() {
      if (scrollController.offset < widget.offset && showToTopBtn) {
        _showToTopBtn = false;
      } else if (scrollController.offset > widget.offset && !showToTopBtn) {
        _showToTopBtn = true;
      }
      if (!isUnMounted) {
        setState(() {
          showToTopBtn = _showToTopBtn;
        });
      }
    });
  }

  backToTop() {
    scrollController.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    //scrollController.dispose();
    super.dispose();
    isUnMounted = true;
  }
  
  @override
  Widget build(BuildContext context) {
    return !showToTopBtn ? Container() : GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: backToTop,
      child: new Icon( 
        IconData(
          0xe696, 
          fontFamily: 'iconfont'
        ),
        color: Color(0xFF70A6FF),
        size: 44,
      ),
    );
  }
}