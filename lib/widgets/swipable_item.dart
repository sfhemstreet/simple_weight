import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

typedef void SizeChangedCallBack(Size newSize);

class LayoutSizeChangeNotification extends LayoutChangedNotification{
  LayoutSizeChangeNotification(this.newSize): super();
  Size newSize;
}

class LayoutSizeChangeNotifier extends SingleChildRenderObjectWidget {
    /// Creates a [SizeChangedLayoutNotifier] that dispatches layout changed
    /// notifications when [child] changes layout size.
    const LayoutSizeChangeNotifier({
        Key key,
        Widget child
    }) : super(key: key, child: child);

    @override
    _SizeChangeRenderWithCallback createRenderObject(BuildContext context) {
        return new _SizeChangeRenderWithCallback(
            onLayoutChangedCallback: (size) {
                new LayoutSizeChangeNotification(size).dispatch(context);
            }
        );
    }
}

class _SizeChangeRenderWithCallback extends RenderProxyBox {
    _SizeChangeRenderWithCallback({
        RenderBox child,
        @required this.onLayoutChangedCallback
    }) : assert(onLayoutChangedCallback != null),
            super(child);

    // There's a 1:1 relationship between the _RenderSizeChangedWithCallback and
    // the `context` that is captured by the closure created by createRenderObject
    // above to assign to onLayoutChangedCallback, and thus we know that the
    // onLayoutChangedCallback will never change nor need to change.

    final SizeChangedCallBack onLayoutChangedCallback;

    Size _oldSize;

    @override
    void performLayout() {
        super.performLayout();
        // Don't send the initial notification, or this will be SizeObserver all
        // over again!
        if (size != _oldSize)
            onLayoutChangedCallback(size);
        _oldSize = size;
    }
}







class ActionItem extends Object{
    ActionItem({@required this.icon,@required this.onPress, this.backgroudColor: CupertinoColors.inactiveGray}){
        assert(icon != null);
        assert(onPress != null);
    }

    final Widget icon;
    final VoidCallback onPress;
    final Color backgroudColor;
}

class SwipableItem extends StatefulWidget {
    SwipableItem({Key key, @required this.items, @required this.child, this.backgroundColor: CupertinoColors.white}):super(key:key){
        assert(items.length <= 6);
    }

    final List<ActionItem> items;
    final Widget child;
    final Color backgroundColor;

    @override
    _SwipableItemState createState() => _SwipableItemState();
}

class _SwipableItemState extends State<SwipableItem> {
    ScrollController controller = new ScrollController();
    bool isOpen = false;

    Size childSize;

    @override
    void initState() {
     super.initState();

    }

    bool _handleScrollNotification(dynamic notification) {
      if(controller.offset > 0){
        setState(() {
          isOpen = true;
        });
      }
      else {
        setState(() {
          isOpen = false;
        });
      }

      if(controller.offset > widget.items.length * 70.0){
        scheduleMicrotask((){
          controller.animateTo(widget.items.length * 60.0, duration: new Duration(milliseconds: 400), curve: Curves.decelerate);
        });
      }

      if (notification is ScrollEndNotification) {
        if (notification.metrics.pixels >= (widget.items.length * 50.0)/2 
          && notification.metrics.pixels < widget.items.length * 50.0)
        {
          scheduleMicrotask((){
            controller.animateTo(widget.items.length * 60.0,
              duration: new Duration(milliseconds: 600), curve: Curves.decelerate);
          });
        }
        else if (notification.metrics.pixels > 0.0 && notification.metrics.pixels < (widget.items.length * 70.0)/2){
          
          scheduleMicrotask((){
              controller.animateTo(0.0, duration: new Duration(milliseconds: 600), curve: Curves.decelerate);
          });
        }
      }

      return true;
    }

    @override
    Widget build(BuildContext context) {
      if (childSize == null){
        return NotificationListener(
          child: LayoutSizeChangeNotifier(
            child: widget.child,
          ),
          onNotification: (LayoutSizeChangeNotification notification){
            childSize = notification.newSize;
      
            scheduleMicrotask((){
                setState((){});
            });

            return true;
          },

        );
      }

      List<Widget> above = <Widget>[
        Container(
          width: childSize.width,
          height: childSize.height,
          color: widget.backgroundColor,
          child: widget.child,
        ),
      ];

      List<Widget> under = <Widget>[];

      for (ActionItem item in widget.items){
        under.add(
          AnimatedOpacity(
            opacity: isOpen ? 1.0 : 0,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Container(
              alignment: Alignment.center,
              color: item.backgroudColor,
              width: 60.0,
              height: childSize.height,
              child: item.icon,
            ),
          ),
        );

        above.add(
          CupertinoButton(
            child: Container(
              alignment: Alignment.center,
              width: 60.0,
              height: childSize.height,
            ),
            onPressed: () {
              controller.animateTo(0.0, duration: new Duration(milliseconds: 600), curve: Curves.decelerate);
              item.onPress();
            }
          )
        );
      }

      Widget items = Container(
        width: childSize.width,
        height: childSize.height,
        color: widget.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: under,
        ),
      );

      Widget scrollview = NotificationListener(
        child: ListView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: above,
        ),
        onNotification: _handleScrollNotification,
      );

      return Stack(
        children: <Widget>[
          items,
          Positioned(child: scrollview, left: 0.0, bottom: 0.0, right: 0.0, top: 0.0,),
        ],
      );
    }
}