import 'package:flutter/material.dart';

class MultiTickerPage extends StatefulWidget {
  const MultiTickerPage({super.key});

  @override
  State<MultiTickerPage> createState() => _MultiTickerPageState();
}

class _MultiTickerPageState extends State<MultiTickerPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _textController;

  late Animation<Size?> _size;
  late Animation<Rect?> _rect;
  late Animation<Color?> _color;
  late Animation<EdgeInsets?> _padding;
  late Animation<BorderRadius?> _radius;

  late Animation<TextStyle?> _textStyle;
  late Animation<Alignment?> _alignment;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _color = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_mainController);

    _size = SizeTween(
      begin: Size(100, 120),
      end: Size(200, 200),
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.ease));

    _radius =
        BorderRadiusTween(
          begin: BorderRadius.circular(0),
          end: BorderRadius.circular(30),
        ).animate(
          CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
        );

    _rect = RectTween(
      begin: const Rect.fromLTWH(0, 0, 120, 120),
      end: const Rect.fromLTWH(0, 0, 220, 180),
    ).animate(_mainController);

    _padding = EdgeInsetsTween(
      begin: EdgeInsets.all(8),
      end: EdgeInsets.all(32),
    ).animate(_mainController);

    _textStyle =
        TextStyleTween(
          begin: TextStyle(fontSize: 18, color: Colors.white),
          end: TextStyle(fontSize: 30, color: Colors.black),
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
        );
    _alignment = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(_textController);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TickerProvider + Other Tweens')),
        body: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_mainController, _textController]),
            builder: (context, _) {
              return Container(
                padding: _padding.value,
                alignment: _alignment.value,
                decoration: BoxDecoration(
                  color: _color.value,
                  borderRadius: _radius.value,
                ),
                width: _size.value?.width,
                height: _size.value?.height,
                child: Text(_rect.value.toString(), style: _textStyle.value),
              );
            },
          ),
        ),
      ),
    );
  }
}
