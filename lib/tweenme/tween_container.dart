import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tweenme/tweenme/tweenme.dart';

/// A widget that can be targeted by a [TweenMe] class.
/// This is an universal widget that can be placed inside any other widgets.
class TweenContainer extends StatefulWidget {
  /// Creates a new tween-able container widget that can apply `TweenMe`.
  ///
  /// The [data] argument must not be null.
  /// 
  TweenContainer({
    Key key, 
    this.name,
    this.data,
    this.child,
  }) : super(
    key: key
  );

  /// Hold all displayed data of the container.
  TweenData data;

  _TweenContainerState _state;
  List<TweenMe> _tweens = [];

  /// The child contained by this container.
  final Widget child;
  final String name;

  /// The state from the closest instance of this class that encloses the given context.
  static _TweenContainerState of(BuildContext context){
    return context.ancestorStateOfType(TypeMatcher<_TweenContainerState>());
  }

  /// Update the new values of `data` to this container.
  void update(){
    _state?.update();
  }

  /// Set values of `data` to this container.
  void set(TweenData newData){
    if(newData.visible != null) data.visible = newData.visible;
    if(newData.opacity != null) data.opacity = newData.opacity;
    if(newData.color != null) data.color = newData.color;
    if(newData.rotation != null) data.rotation = newData.rotation;
    if(newData.scale != null) data.scale = newData.scale;
    if(newData.left != null) data.left = newData.left;
    if(newData.top != null) data.top = newData.top;
    if(newData.bottom != null) data.bottom = newData.bottom;
    if(newData.right != null) data.right = newData.right;
    if(newData.width != null) data.width = newData.width;
    if(newData.height != null) data.height = newData.height;
    if(newData.margin != null) data.margin = newData.margin;
    if(newData.padding != null) data.padding = newData.padding;
    if(newData.border != null) data.border = newData.border;
    if(newData.borderRadius != null) data.borderRadius = newData.borderRadius;
    if(newData.transformOrigin != null) data.transformOrigin = newData.transformOrigin;

    if(newData.left != null && newData.right != null) data.width = null;
    if(newData.top != null && newData.bottom != null) data.height = null;
    
    update();
  }

  /// Dispose a specific tween on this container.
  void killTween(TweenMe tween){
    _tweens.remove(tween);
    tween.dispose();
  }

  /// Add a new tween to this container's list.
  void add(TweenMe tween){
    _tweens.add(tween);
  }

  /// Dispose this container and all of its tweens.
  void dispose(){
    if(_tweens.length > 0){
      for(int i=0; i<_tweens.length; i++){
        _tweens[i].dispose();
      }
      _tweens = [];
    }
    // _state?.dispose();
  }

  @override
    _TweenContainerState createState(){
      _state = new _TweenContainerState();
      return _state;
  }
}

class _TweenContainerState extends State<TweenContainer> {
  String parentRenderType;

  TweenData data;

  bool shouldSetPosition = false;
  
  @override
    void initState() {

      data = (widget.data != null) ? widget.data : TweenData();

      // get parent widget type:
      parentRenderType = context.ancestorRenderObjectOfType(TypeMatcher<RenderObject>()).runtimeType.toString();
      // print("parentRenderType = $parentRenderType");

      shouldSetPosition = (parentRenderType == "RenderStack");
      // print("shouldSetPosition: $shouldSetPosition");

      if(data.visible == null) data.visible = true;
      if(data.opacity == null || data.opacity > 1) data.opacity = 1;
      if(data.opacity < 0) data.opacity = 0;
      if(data.rotation == null) data.rotation = 0;
      if(data.transformOrigin == null) data.transformOrigin = Offset(0.5, 0.5);
      if(data.scale == null) data.scale = Offset(1, 1);
      
      // check for exceptions:

      if(data.left != null && data.right != null && data.width != null){
        data.width = null;
        print('[TweenContainer] If you used "left" and "right", the value of "width" will have no effects.');
      }

      if(data.top != null && data.bottom != null && data.height != null){
        data.height = null;
        print('[TweenContainer] If you used "top" and "bottom", the value of "height" will have no effects.');
      }

      widget.data = data;

      super.initState();
    }

  @override
    void dispose() {
      // print("disposed");
      widget._state = null;
      super.dispose();
    }

  @override
    void didUpdateWidget(TweenContainer oldWidget) {
      widget._state = this;
      
      // get parent widget type:
      parentRenderType = context.ancestorRenderObjectOfType(TypeMatcher<RenderObject>()).runtimeType.toString();
      shouldSetPosition = (parentRenderType == "RenderStack");
      // print("parentRenderType = $parentRenderType");

      data = (widget.data != null) ? widget.data : TweenData();
      
      if(data.visible == null) data.visible = true;
      if(data.opacity == null || data.opacity > 1) data.opacity = 1;
      if(data.opacity < 0) data.opacity = 0;
      if(data.rotation == null) data.rotation = 0;
      if(data.transformOrigin == null) data.transformOrigin = Offset(0.5, 0.5);
      if(data.scale == null) data.scale = Offset(1, 1);

      if(data.left != null && data.right != null && data.width != null){
        data.width = null;
        print('[TweenContainer] If you used "left" and "right", the value of "width" will have no effects.');
      }

      if(data.top != null && data.bottom != null && data.height != null){
        data.height = null;
        print('[TweenContainer] If you used "top" and "bottom", the value of "height" will have no effects.');
      }

      widget.data = data;
      print(widget.data);

      // print("[UPDATE] Current size: ${data.width} x ${data.height}");
      
      super.didUpdateWidget(oldWidget);
    }

  void update(){
    if(mounted){
      setState(() {
        data = widget.data;

        if(data.opacity == null || data.opacity > 1) data.opacity = 1;
        if(data.opacity < 0) data.opacity = 0;
        if(data.rotation == null) data.rotation = 0;
        if(data.scale == null) data.scale = Offset(1, 1);
        // if(data.transformOrigin == null) data.transformOrigin = Offset(0.5, 0.5);

        if(shouldSetPosition && data.left != null && data.right != null) data.width = null;
        if(shouldSetPosition && data.top != null && data.bottom != null) data.height = null;
        // print("[UPDATE] => Current size: ${data.width} x ${data.height}");
      });
    }
  }

  Widget build(BuildContext context) {
    
    Widget container;
    Widget myChild;
    Matrix4 transformMatrix;

    Widget wrapper = Container(
      width: data.width,
      height: data.height,
      padding: data.padding,
      margin: data.margin,
      decoration: BoxDecoration(
        color: data.color,
        border: data.border,
        borderRadius: data.borderRadius,
        image: data.backgroundImage
      ),
      child: widget.child
    );

    if(data.opacity != 1 || (data.opacity == 1 && widget.data.opacity != 1)){
      myChild = Opacity(
        opacity: data.opacity,
        child: wrapper
      );
    } else {
      myChild = wrapper;
    }

    if((data.rotation == 0 && widget.data.rotation != 0) || data.rotation != 0){
      transformMatrix = Matrix4.rotationZ(data.rotation * math.pi / 180);
    }

    if((data.scale.dx == 1 && widget.data.scale.dx != 1) || data.scale.dx != 1 || (data.scale.dy == 1 && widget.data.scale.dy != 1) || data.scale.dy != 1){
      if(transformMatrix == null){
        transformMatrix = Matrix4.zero()..scale(data.scale.dx, data.scale.dy);
      } else {
        transformMatrix = transformMatrix..scale(data.scale.dx, data.scale.dy);
      }
    }

    if(transformMatrix != null){
      myChild = Transform(
        alignment: FractionalOffset(data.transformOrigin.dx, data.transformOrigin.dy),
        transform: transformMatrix,
        child: myChild
      );
    }

    if(parentRenderType == "RenderFlex" || parentRenderType == "RenderPositionedBox"){
      container = myChild;
    } else {
      container = Positioned(
        top: data.top,
        left: data.left,
        right: data.right,
        bottom: data.bottom,
        width: data.width,
        height: data.height,
        child: myChild
      );
    }

    return (data.visible) ? container : Container();
  }
}
