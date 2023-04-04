import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _textController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final _progressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  var items = List.generate(5, (index) => null);

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future onRefresh() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );
    _textController.animateTo(1, curve: Curves.easeInOut);
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );
    _progressController.animateTo(1, curve: Curves.easeInOut);
    await Future<void>.delayed(
      const Duration(milliseconds: 3000),
    );
    _progressController.animateTo(0, curve: Curves.easeInOut);
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    _textController.animateTo(0, curve: Curves.easeInOut);
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xff004CFE);

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 130,
              refreshIndicatorExtent: 100,
              builder: (_, __, pulledExtent, ___, ____) {
                if (pulledExtent != 60.0) {
                  _controller.animateTo(pulledExtent / 200);
                }
                return Stack(
                  children: [
                    Center(
                      child: AnimatedBuilder(
                        animation: _textController,
                        child: Container(),
                        builder: (context, widget) {
                          return Text(
                            'TEKRAM',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(1 - _textController.value),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6 + (50 * _textController.value),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: AnimatedBuilder(
                        animation: _progressController,
                        child: Container(),
                        builder: (context, widget) {
                          var scale = 30 * _progressController.value;
                          return SizedBox(
                            width: scale,
                            height: scale,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              onRefresh: onRefresh,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedBuilder(
                      animation: _controller,
                      child: Container(
                        height: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      builder: (context, widget) {
                        double rotateX = ((-45 * _controller.value) / 180 * pi);
                        double translateY =
                            (30 - index * 20) * _controller.value;
                        double marginVertical = 12 - (12 * _controller.value);

                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: marginVertical),
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(rotateX)
                              ..translate(0.0, translateY),
                            alignment: Alignment.center,
                            child: widget,
                          ),
                        );
                      });
                },
                childCount: items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
