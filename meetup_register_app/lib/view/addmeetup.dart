import 'package:flutter/material.dart';
import 'package:meetup_register_app/model/meetup.dart';

class AddMeetUP extends StatefulWidget {
  final List<MeetUp> meetUpList1;
  const AddMeetUP({super.key, required this.meetUpList1});

  @override
  State<AddMeetUP> createState() => _AddMeetUPState();
}

class _AddMeetUPState extends State<AddMeetUP> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임 등록'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.meetUpList1[0].mapURL),
          ],
        ),
      ),
    );
  }
}