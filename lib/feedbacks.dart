import 'package:flutter/material.dart';

class FeedBacksWidget extends StatefulWidget {
  const FeedBacksWidget({super.key});

  @override
  State<FeedBacksWidget> createState() => _FeedBacksWidgetState();
}

class _FeedBacksWidgetState extends State<FeedBacksWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Center(
            child: Text("FeedBacks", style: TextStyle(color: Colors.black)),
          ),
        ),
        body: Center(child: Text("List of Feedback")));
  }
}
