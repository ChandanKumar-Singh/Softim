import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../ApiManager/Apis.dart';
import '../../Model/Attendance.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();

  DateTime _targetDateTime = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime lastDate = DateTime.now();
  DateTime admissionDate = DateTime(2019, 2, 3);

  List<Attendance> attendanceList = [];
  List<Attendance> absentList = [];

  Future<DateTime?> getAttendanceDetails() async {
    String url = ApiManager.BASE_URL + ApiManager.getAttendance;
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    try {
      var response = await http.post(Uri.parse(url), headers: headers);
      // debugPrint('AttendanceResponse = ${response.body}');
      var responseData = await json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var message = responseData['message'];
          var data = responseData['data'];
          attendanceList.clear();
          data.forEach((v) {
            attendanceList.add(Attendance.fromJson(v));
          });
          if (attendanceList.isNotEmpty) {
            attendanceList.sort((a, b) {
              return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
            });
          }

          admissionDate = DateTime.parse(attendanceList.first.date!);
          // lastDate = DateTime.parse(attendanceList.last.date!);
          absentList.clear();
          absentList = attendanceList
              .where((element) => element.isPresent == 0.toString())
              .toList();

          print(absentList.length);
          print(admissionDate);
          print(lastDate);
          return admissionDate;
        }
        return null;
      }
    } catch (e) {
      debugPrint('Some Error happened');
    }
    return null;
  }

  void initCalender() async {
    await getAttendanceDetails();
  }

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2022, 5, 6): [
        Event(
          date: DateTime(2022, 5, 6),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        Event(
          date: DateTime(2022, 5, 6),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        Event(
          date: DateTime(2022, 5, 6),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  @override
  void initState() {
    initCalender();

    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        DateTime(2019, 2, 25),
        Event(
          date: DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        DateTime(2019, 2, 10),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(DateTime(2019, 2, 11), [
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(absentList.length);
    // print(admissionDate);
    // print(lastDate);

    /// Example Calendar Carousel without header and custom prev & next button

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presence Details '),
      ),
      body: FutureBuilder(
          future: getAttendanceDetails(),
          builder: (context, snap) {
            if (!snap.hasError) {
              if (snap.data != null) {
                final txtTheme = Theme.of(context).textTheme;
                final colorTheme = Theme.of(context);
/*
                bool wasAbsent = absentList.any((element) =>
                    DateFormat('yyyy-MM-dd').format(dateTime) ==
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(absentList.first.date!)));

                bool wasPresent =
                    (attendanceList.toSet().difference(absentList.toSet()))
                        .toList()
                        .any((element) =>
                            DateFormat('yyyy-MM-dd').format(dateTime) ==
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(element.date!)));
                // print(wasPresent);
                var daysText = Align(
                  child: Text(
                    '${dateTime.day}',
                    style: dateTime.weekday == 7 && isDisabled
                        ? txtTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.red.withOpacity(0.4))
                        : dateTime.weekday == 7 && !isDisabled
                            ? txtTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18)
                            : isDisabled
                                ? txtTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54)
                                : isSelected
                                    ? txtTheme.bodyText2!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: colorTheme.brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.blue)
                                    : isHighlighted
                                        ? txtTheme.bodyText1!.copyWith(
                                            fontWeight: FontWeight
                                                .bold) //Highlighted TextStyle
                                        : isCurrentDay
                                            ? txtTheme
                                                .bodyText1 //CurrentDay TextStyle
                                            : txtTheme.bodyText1,
                  ),
                );*/
                final _calendarCarouselNoHeader = CalendarCarousel<Event>(
                  todayBorderColor: Colors.green,
                  onDayPressed: (date, events) {
                    setState(() => selectedDate = date);
                    for (var event in events) {
                      print(event.title);
                    }
                  },
                  daysHaveCircularBorder: true,
                  showOnlyCurrentMonthDate: false,
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
//      firstDayOfWeek: 4,
                  markedDatesMap: _markedDateMap,
                  height: 420.0,
                  selectedDateTime: selectedDate,
                  targetDateTime: _targetDateTime,
                  customGridViewPhysics: const NeverScrollableScrollPhysics(),
                  markedDateCustomShapeBorder:
                      const CircleBorder(side: BorderSide(color: Colors.amber)),
                  markedDateCustomTextStyle:
                      const TextStyle(fontSize: 18, color: Colors.blue),
                  showHeader: true,
                  todayTextStyle: const TextStyle(color: Colors.white),
                  // markedDateShowIcon: true,
                  // markedDateIconMaxShown: 2,
                  // markedDateIconBuilder: (event) {
                  //   return event.icon;
                  // },
                  // markedDateMoreShowTotal:
                  //     true,
                  todayButtonColor: Colors.blue,
                  selectedDayTextStyle: const TextStyle(color: Colors.yellow),
                  minSelectedDate: admissionDate,
                  maxSelectedDate: DateTime.now(),
                  prevDaysTextStyle:
                      const TextStyle(fontSize: 16, color: Colors.grey),
                  inactiveDaysTextStyle:
                      const TextStyle(color: Colors.grey, fontSize: 16),

                  onCalendarChanged: (DateTime date) {
                    setState(() {
                      _targetDateTime = date;
                      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                  onDayLongPressed: (DateTime date) {
                    print('long pressed date $date');
                  },
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFA14BE7)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  attendanceList
                                      .toSet()
                                      .difference(absentList.toSet())
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0x8FFC0000)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  absentList.length.toString(),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Absent',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width / 4,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFFFFFFF)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  attendanceList.length.toString(),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              13,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Total Classes',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     top: 30.0,
                    //     bottom: 16.0,
                    //     left: 16.0,
                    //     right: 16.0,
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //           child: Text(
                    //         _currentMonth,
                    //         style: const TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 24.0,
                    //         ),
                    //       )),
                    //       TextButton(
                    //         child: const Text('PREV'),
                    //         onPressed: () {
                    //           setState(() {
                    //             _targetDateTime = DateTime(_targetDateTime.year,
                    //                 _targetDateTime.month - 1);
                    //             _currentMonth =
                    //                 DateFormat.yMMM().format(_targetDateTime);
                    //           });
                    //         },
                    //       ),
                    //       TextButton(
                    //         child: const Text('NEXT'),
                    //         onPressed: () {
                    //           setState(() {
                    //             _targetDateTime = DateTime(_targetDateTime.year,
                    //                 _targetDateTime.month + 1);
                    //             _currentMonth =
                    //                 DateFormat.yMMM().format(_targetDateTime);
                    //           });
                    //         },
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _calendarCarouselNoHeader,
                    ), //
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else {
              return const Center(
                child: Text('Some Error Has Occurred'),
              );
            }
          }),
    );
  }
}
