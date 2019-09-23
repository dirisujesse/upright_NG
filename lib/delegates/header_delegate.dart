import 'package:flutter/material.dart';

class UprightSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  UprightSliverAppBarDelegate({@required this.child,});

  @override

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(UprightSliverAppBarDelegate oldDelegate) {
    return false;
  }
}