import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  final Icon? icon;
  final Widget child;
  final bool hideIcon;
  final Color? iconColor;
  final bool leadingIcon;
  final bool canAddValue;
  final bool indexZeroNotSelected;
  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;
  final void Function(T, int)? onChange;
  final DropdownButtonStyle dropdownButtonStyle;

  const AppDropdown({
    super.key,
    this.icon,
    this.onChange,
    required this.child,
    required this.items,
    this.hideIcon = false,
    this.canAddValue = true,
    this.leadingIcon = false,
    this.iconColor = Colors.black,
    this.indexZeroNotSelected = false,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
  });

  static AppDropdown<String> string({
    Key? key,
    Icon? icon,
    void Function(String, int)? onChange,
    required List<String> dataList,
    required Widget child,
    bool hideIcon = false,
    bool canAddValue = true,
    bool leadingIcon = false,
    Color? iconColor = Colors.black,
    bool indexZeroNotSelected = false,
    DropdownStyle dropdownStyle = const DropdownStyle(),
    DropdownButtonStyle dropdownButtonStyle = const DropdownButtonStyle(),
  }) {
    return AppDropdown<String>(
      key: key,
      icon: icon,
      onChange: onChange,
      hideIcon: hideIcon,
      iconColor: iconColor,
      canAddValue: canAddValue,
      leadingIcon: leadingIcon,
      dropdownStyle: dropdownStyle,
      items: _mapStringList(dataList),
      dropdownButtonStyle: dropdownButtonStyle,
      indexZeroNotSelected: indexZeroNotSelected,
      child: child,
    );
  }

  static List<DropdownItem<String>> _mapStringList(List<String> list) {
    return list
        .map(
          (str) => DropdownItem<String>(
            value: str,
            child: Padding(padding: const EdgeInsets.all(8), child: Text(str)),
          ),
        )
        .toList();
  }

  @override
  AppDropdownState<T> createState() => AppDropdownState<T>();
}

class AppDropdownState<T> extends State<AppDropdown<T>>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int _currentIndex = -1;
  bool _isOpen = false;

  DropdownStyle get dropdownStyle => widget.dropdownStyle;
  DropdownButtonStyle get dropdownButtonStyle => widget.dropdownButtonStyle;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: dropdownButtonStyle.width,
        height: dropdownButtonStyle.height,
        child: InkWell(
          onTap: _toggleDropdown,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment:
                  dropdownButtonStyle.mainAxisAlignment ??
                  MainAxisAlignment.center,
              textDirection: widget.leadingIcon
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              children: [
                Expanded(
                  child: _currentIndex == -1
                      ? widget.child
                      : widget.items[_currentIndex],
                ),
                if (!widget.hideIcon)
                  RotationTransition(
                    turns: _rotateAnimation,
                    child:
                        widget.icon ??
                        Icon(Icons.expand_more, color: widget.iconColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;

    var topOffset = offset.dy + size.height + 5;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: dropdownStyle.elevation ?? 0,
                    borderRadius: dropdownStyle.borderRadius,
                    color: dropdownStyle.color,
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      axisAlignment: 1,
                      child: ConstrainedBox(
                        constraints:
                            dropdownStyle.constraints ??
                            BoxConstraints(
                              maxHeight:
                                  MediaQuery.sizeOf(context).height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding: dropdownStyle.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return InkWell(
                              onTap: () {
                                if (widget.indexZeroNotSelected && index == 0) {
                                  return;
                                }

                                if (widget.canAddValue) {
                                  setState(() => _currentIndex = index);
                                }

                                widget.onChange?.call(item.value, index);

                                _toggleDropdown();
                              },
                              child: item,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry?.remove();
      setState(() => _isOpen = false);
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) => child;
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Offset? offset;
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}



  // Widget _buildStyledItem(Widget child, bool selected) {
  //   if (!selected) return child;
  //   if (child is Text) {
  //     return Text(
  //       child.data!,
  //       style:
  //           child.style?.copyWith(
  //             fontWeight: FontWeight.bold,
  //             color: Colors.red,
  //           ) ??
  //           const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  //     );
  //   }
  //   return DefaultTextStyle.merge(
  //     style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  //     child: child,
  //   );
  // }