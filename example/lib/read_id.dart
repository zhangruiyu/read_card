import 'dart:async';

import 'package:flutter/material.dart';
import 'package:read_card/model/read_id_result.dart';
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
  IdCardResponse? idCardResponse;
  @override
  void initState() {
    super.initState();
    () async {
      readCard.readId();
    }();

    subscription = MethodChannelReadCard.onDartMessageListener.listen((event) {
      print('123123213 ${event.params}');
      if (event is IdCardResponse) {
        setState(() {
          idCardResponse = event;
        });
      } else {}
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
            Text(idCardResponse.toString()),
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
