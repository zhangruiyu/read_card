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
  IdCardSuccessResponse? idCardResponse;

  @override
  void initState() {
    super.initState();
    () async {
      readCard.readId();
    }();

    subscription = MethodChannelReadCard.onDartMessageListener.listen((event) {
      if (event is IdCardSuccessResponse) {
        setState(() {
          idCardResponse = event;
        });
      } else if(event is IdCardFailedResponse){
        ///处理错误逻辑,除了错误码里的，新增了2个错误码，10000（设备没有NFC），10001（NFC没打开）
        debugPrint('错误了:${event.toString()}');
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
      body: Column(
        children: [
          if (idCardResponse != null) ...[
            Container(margin: const EdgeInsets.all(20),child: Text(idCardResponse.toString())),
            if (idCardResponse!.picture != null)
              Image.memory(
                idCardResponse!.picture!,
                width: 200,
              )
          ]
        ],
      ),
    );
  }
}
