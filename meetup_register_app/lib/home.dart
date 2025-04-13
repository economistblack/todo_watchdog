import 'package:flutter/material.dart';
import 'package:meetup_register_app/model/meetup.dart';
import 'package:meetup_register_app/view/bulletinmeetup.dart';
import 'package:meetup_register_app/view/registereetup.dart';

class Home extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const Home({super.key, required this.onChangeTheme});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int _meetUpId;
  late String _meetUpBanner;
  late String _organizerImage;
  late String _organizerName;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late Duration _meetUpDuration;
  late String _meetUpLocation;
  late String _mapURL;
  late String _meetUpTitle;
  late String _meetUpContent;
  late String _meetUpFee;
  late int _maxNumOfAttendees;
  late List<MeetUp> meetUpList;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _meetUpId = 1;
    _meetUpBanner = 'images/EconomistCover.png';
    _organizerImage = 'images/user11.png';
    _organizerName = '디카프리오';
    _selectedDate = DateTime(2025, 04, 23);
    _selectedTime = TimeOfDay(hour: 19, minute: 30);
    _meetUpDuration = Duration(hours: 2);
    _meetUpLocation = '스타벅스 가락본동점';
    _mapURL = 'https://maps.app.goo.gl/vyhgS5WzoV6GqP3AA';
    _meetUpTitle = 'Economist Cover';
    _meetUpContent = '삽화 인사이트 및 번역 공유';
    _meetUpFee = '각자 음료비';
    _maxNumOfAttendees = 8;
    meetUpList = [];

    meetUpList.add(MeetUp(
      meetUpId: _meetUpId,
      meetUpBanner: _meetUpBanner,
      organizerImage: _organizerImage,
      organizerName: _organizerName,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      meetUpDuration: _meetUpDuration,
      meetUpLocation: _meetUpLocation,
      mapURL: _mapURL,
      meetUpTitle: _meetUpTitle,
      meetUpContent: _meetUpContent,
      meetUpFee: _meetUpFee,
      maxNumOfAttendees: _maxNumOfAttendees,
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: [Tab(text: '모임'), Tab(text: '게시판')],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          RegisterMeetUp(
            meetUpList: meetUpList,
            onChangeTheme: widget.onChangeTheme,
          ),
          BulletinMeetUp(onChangeTheme: widget.onChangeTheme),
        ],
      ),
    );
  }
}
