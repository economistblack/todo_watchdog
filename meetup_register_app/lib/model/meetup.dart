import 'package:flutter/material.dart';

class MeetUp {
  final int meetUpId;
  final String meetUpBanner;
  final String organizerImage;
  final String organizerName;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String weekDay;
  final Duration meetUpDuration;
  final String meetUpLocation;
  final String mapURL;
  final String meetUpTitle;
  final String meetUpContent;
  final String meetUpFee;
  final int maxNumOfAttendees;

  MeetUp({
    required this.meetUpId,
    required this.meetUpBanner,
    required this.organizerImage,
    required this.organizerName,
    required this.selectedDate,
    required this.selectedTime,
    required this.weekDay,
    required this.meetUpDuration,
    required this.meetUpLocation,
    required this.mapURL,
    required this.meetUpTitle,
    required this.meetUpContent,
    required this.meetUpFee,
    required this.maxNumOfAttendees,
  });
}
