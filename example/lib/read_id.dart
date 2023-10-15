import 'dart:async';

import 'package:flutter/material.dart';
import 'package:read_card/read_card.dart';
import 'package:read_card/read_card_method_channel.dart';

class ReadID extends StatefulWidget {
  const ReadID({super.key});

  @override
  State<ReadID> createState() => _ReadIDState();
}

class _ReadIDState extends State<ReadID> {
  final readCard = ReadCard();
  late final StreamSubscription<NativeResponse> subscription;

  @override
  void initState() {
    super.initState();
    readCard.readId();
    subscription = MethodChannelReadCard.onDartMessageListener.listen((event) {
      if (event is IdOnSuccessNativeResponse) {

      }else{

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    readCard.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC读取身份证/elD电子证照'),
      ),
    );
  }
}
