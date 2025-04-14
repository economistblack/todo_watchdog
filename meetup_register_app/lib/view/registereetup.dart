import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetup_register_app/model/meetup.dart';
import 'package:intl/intl.dart';
import 'package:meetup_register_app/view/addmeetup.dart';

class RegisterMeetUp extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  final List<MeetUp> meetUpList;
  const RegisterMeetUp({
    super.key,
    required this.onChangeTheme,
    required this.meetUpList,
  });

  @override
  State<RegisterMeetUp> createState() => _RegisterMeetUpState();
}

class _RegisterMeetUpState extends State<RegisterMeetUp> {
  
  
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.meetUpList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            children: [
                              Text(
                                '모임 주제 : ${widget.meetUpList[index].meetUpTitle}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  widget.meetUpList[index].meetUpBanner,
                                  width: 120,
                                  height:100,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        widget.meetUpList[index].organizerImage,
                                      ),
                                      radius: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Text(
                                        widget.meetUpList[index].organizerName,
                                        style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onTertiary,),
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '날짜: ${DateFormat('yyyy년 MM월 dd일').format(widget.meetUpList[index].selectedDate)} (${widget.meetUpList[index].weekDay})',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                    Text(
                                      '시간: ${(widget.meetUpList[index].selectedTime).format(context)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                    Text(
                                      '장소: ${widget.meetUpList[index].meetUpLocation}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(AddMeetUP(meetUpList1: widget.meetUpList));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                minimumSize: Size(250, 40),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              label: Text('모임 만들기'),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
