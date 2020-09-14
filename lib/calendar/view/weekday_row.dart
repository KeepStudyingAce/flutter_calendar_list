import 'package:flutter/material.dart';

class WeekdayRow extends StatelessWidget {
  WeekdayRow(
      {Key key,
      this.weekendColor = Colors.black,
      this.workDayColor = Colors.black});

  /// 周末日期样式
  final Color weekendColor;

  /// 工作日日期样式
  final Color workDayColor;

  Widget _weekdayContainer(String weekDay) => Expanded(
        child: Container(
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color:
                    ["日", "六"].contains(weekDay) ? weekendColor : workDayColor,
                fontSize: 14.0,
              ),
              child: Text(
                weekDay,
              ),
            ),
          ),
        ),
      );

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    list.add(_weekdayContainer("日"));
    list.add(_weekdayContainer("一"));
    list.add(_weekdayContainer("二"));
    list.add(_weekdayContainer("三"));
    list.add(_weekdayContainer("四"));
    list.add(_weekdayContainer("五"));
    list.add(_weekdayContainer("六"));
    return list;
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _renderWeekDays(),
      );
}
