import 'dart:async';

import 'package:flutter/material.dart';
import 'package:read_card/read_card.dart';

import 'read_id.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:  Root(),
    );
  }
}
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool initSuccess = false;
  final _readCardPlugin = ReadCard();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool initStatus = await _readCardPlugin.initEid(
        appId: '1190807',
        ip: "testeidcloudread.eidlink.com",
        port: 9989,
        envCode: 26814);
    setState(() {
      initSuccess = initStatus;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text('初始化结果:$initSuccess'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const ReadID();
                }));
              },
              child: const Text('NFC读取身份证/elD电子证照'),
            ),
          ],
        ),
      ),
    );
  }
}
