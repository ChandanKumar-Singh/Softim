import 'dart:convert';

import 'package:calendar_builder/calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../ApiManager/Apis.dart';
import '../../Model/Attendance.dart';

class PresenceDetails extends StatefulWidget {
  const PresenceDetails({Key? key}) : super(key: key);

  @override
  State<PresenceDetails> createState() => _PresenceDetailsState();
}

class _PresenceDetailsState extends State<PresenceDetails> {
  DateTime admissionDate = DateTime.now();
  DateTime lastDate = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    initCalender();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presence Details '),
      ),
      body: FutureBuilder(
          future: getAttendanceDetails(),
          builder: (context, snap) {
            if (!snap.hasError) {
              if (snap.data != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
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
                                  color: Color(0xFFA14BE7)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  color: Color(0x8FFC0000)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  color: Color(0xFFFFFFFF)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                      Expanded(
                        child: CbMonthBuilder(
                          cbConfig: CbConfig(
                              currentDay: DateTime.now(),
                              startDate: admissionDate,
                              endDate: lastDate,
                              selectedDate: DateTime.now(),
                              selectedYear: DateTime(DateTime.now().year),
                              weekStartsFrom: WeekStartsFrom.monday,
                              eventDates: [
                                // DateTime(2022, 1, 3)
                              ],
                              highlightedDates: [
                                // DateTime(2022, 1, 3)
                              ]),
                          yearDropDownCustomizer: YearDropDownCustomizer(
                            yearHeaderBuilder: (isYearPickerExpanded,
                                selectedDate, selectedYear, year) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: const Color(0x931E4FF1),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xB87E7D7D),
                                        blurRadius: 3,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      year,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      !isYearPickerExpanded
                                          ? Icons.arrow_drop_down_outlined
                                          : Icons.arrow_drop_up_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          monthCustomizer: MonthCustomizer(
                            scrollToSelectedMonth: true,
                            montMinhHeight: 300,
                            monthMinWidth:
                                MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.all(10),
                            monthHeaderBuilder: (month, headerHeight,
                                headerWidth, paddingLeft) {
                              return Container(
                                height: headerHeight,
                                width: headerWidth,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    month,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                            monthWeekBuilder:
                                (index, weeks, weekHeight, weekWidth) {
                              return SizedBox(
                                height: weekHeight,
                                width: weekWidth,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.15))),
                                    child: Align(
                                      child: Text(
                                        weeks,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: index == 6
                                              ? Colors.red
                                              : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            monthButtonBuilder: (dateTime,
                                childHeight,
                                childWidth,
                                isSelected,
                                isDisabled,
                                hasEvent,
                                isHighlighted,
                                isCurrentDay) {
                              final txtTheme = Theme.of(context).textTheme;
                              final colorTheme = Theme.of(context);

                              bool wasAbsent = absentList.any((element) =>
                                  DateFormat('yyyy-MM-dd').format(dateTime) ==
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(absentList.first.date!)));
                              // List l = (attendanceList
                              //         .toSet()
                              //         .difference(absentList.toSet()))
                              //     .toList();
                              // print(l);
                              // print(l);
                              // print(l.length);
                              bool wasPresent = (attendanceList
                                      .toSet()
                                      .difference(absentList.toSet()))
                                  .toList()
                                  .any((element) =>
                                      DateFormat('yyyy-MM-dd')
                                          .format(dateTime) ==
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(element.date!)));
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: colorTheme
                                                                  .brightness ==
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
                              );
                              if (isSelected && wasAbsent) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    daysText,
                                    const Text(
                                      'Absent',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ],
                                );
                              }
                              if (isSelected && wasPresent) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    daysText,
                                    const Text(
                                      'Present',
                                      style: TextStyle(
                                          fontSize: 9, color: Colors.green),
                                    ),
                                  ],
                                );
                              }
                              if (wasAbsent && !isDisabled) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDisabled
                                        ? const Color(0xFFFFFFFF)
                                            .withOpacity(0.2)
                                        : const Color(0xFFFF0000)
                                            .withOpacity(0.2),
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: daysText,
                                  ),
                                );
                                return Column(
                                  children: [
                                    daysText,
                                    const Text(
                                      'Absent',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ],
                                );
                              }
                              if (wasPresent && !isDisabled) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDisabled
                                        ? const Color(0xFFFFFFFF)
                                            .withOpacity(0.2)
                                        : const Color(0xC575EEB8)
                                            .withOpacity(0.2),
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: daysText,
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDisabled
                                      ? const Color(0xFFFFFFFF).withOpacity(0.2)
                                      : const Color(0x88B7D3EF)
                                          .withOpacity(0.2),
                                ),
                                margin: const EdgeInsets.all(4),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: daysText,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
