import 'package:flutter/material.dart';
import 'package:lets_chat/theme/gradient_provider.dart';
import 'package:provider/provider.dart';

class ReceiverPage extends StatefulWidget {
  final String receiverUid;
  final String receiverName;
  final String receiverEmail;
  const ReceiverPage({
    super.key,
    required this.receiverUid,
    required this.receiverName,
    required this.receiverEmail,
  });

  @override
  State<ReceiverPage> createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  @override
  Widget build(BuildContext context) {
    final gradientProvider = Provider.of<GradientProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor:
            gradientProvider.isSwitched
                ? Color(0xFF5DE0E6)
                : Color(0xFF87CEEB),
        title:
            widget.receiverName.isNotEmpty
                ? Text(widget.receiverName)
                : Text('No User'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradientProvider.currentGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              'Name: ${widget.receiverName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Email: ${widget.receiverEmail}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
