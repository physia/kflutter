// Copyright (c) 2021, @mohamadlounnas
// https://physia.dev
//
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';

void main() async {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexPage(),
      ),
    ),
  );
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  var colors = <Color>[
    Colors.amber,
    Colors.amberAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.red,
    Colors.redAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.brown,
    Colors.teal,
    Colors.tealAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Indexer(
          children: [
            for (var i = 0; i < BoxDemo.boxes.length; i++)
              IndexedExtendsDemo(
                key: BoxDemo.boxes[i].key,
                boxDemo: BoxDemo.boxes[i],
                callback: () {
                  setState(() {});
                },
              )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() {
                BoxDemo.clean(() {
                  setState(() {});
                });
              });
            },
            child: const Icon(
              Icons.clean_hands,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              setState(() {
                int rd = Random().nextInt(colors.length);
                AnimationController _controller = AnimationController(
                  duration: const Duration(milliseconds: 500),
                  vsync: this,
                )..forward();
                BoxDemo.boxes.add(
                  BoxDemo(
                      index: rd, color: colors[rd], controller: _controller),
                );
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class BoxDemo {
  static int topIndex = 100;
  BoxDemo({required this.index, required this.color, required this.controller});
  int index;
  Key key = UniqueKey();
  Color color;
  bool needDelete = false;
  AnimationController controller;
  static var boxes = <BoxDemo>[];

  static void clean(VoidCallback callback) {
    for (var boxDemo in boxes) {
      boxDemo.controller.reverse();
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        BoxDemo.boxes.remove(boxDemo);
      });
    }
    callback();
  }
}

class IndexedExtendsDemo extends AnimatedWidget implements IndexedInterface {
  final BoxDemo boxDemo;
  final VoidCallback? callback;
  IndexedExtendsDemo({
    super.key,
    required this.boxDemo,
    this.callback,
  }) : super(listenable: boxDemo.controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var i = BoxDemo.boxes.indexOf(boxDemo);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: ((size.height / 2) - 50 - BoxDemo.boxes.length * 15) + 30 * i,
      left: ((size.width / 2) - 50 - BoxDemo.boxes.length * 15) + 30 * i,
      child: InkWell(
        onTap: () {
          // setState(() {
          boxDemo.needDelete = true;
          boxDemo.index = BoxDemo.topIndex++;
          callback!();
          // });
        },
        child: Transform.scale(
          scale: _progress.value,
          child: Material(
            elevation: 2,
            child: Container(
              width: 100,
              height: 100,
              color: boxDemo.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${boxDemo.index}",
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      boxDemo.controller.reverse();
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((value) {
                        BoxDemo.boxes.remove(boxDemo);
                        callback!();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 12,
                    ),
                    label: const Text(
                      "DELETE",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  @override
  int get index => boxDemo.index;
}
