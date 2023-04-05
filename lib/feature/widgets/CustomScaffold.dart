import 'package:flutter/material.dart';
import 'package:vent_news/common/theme.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;

  const CustomScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("VentNews",
                style: blackTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            Text("Read Headline News",
                style: greyTextStyle.copyWith(
                    fontSize: 14, fontWeight: FontWeight.normal))
          ],
        ),
        actions: const [
          Icon(
            Icons.newspaper_sharp,
            size: 32,
          )
        ],
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
