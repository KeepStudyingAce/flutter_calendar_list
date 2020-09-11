library calendar_list;

import 'package:flutter/material.dart';

import 'month_view.dart';
import 'weekday_row.dart';

enum CalendarSelectedType { Single, Multiply, Range } //单选多选和范围选择

class CalendarList extends StatefulWidget {
  /// 日历最早日期
  final DateTime firstDate;

  /// 日历最晚日期
  final DateTime lastDate;

  /// 日历选中开始日期
  final DateTime selectedStartDate;

  /// 日历选中结束日期
  final DateTime selectedEndDate;

  /// 日历选中结果回调
  final Function(List<DateTime>) onSelectFinish;

  /// 日历选择模式
  final CalendarSelectedType selectedType;

  /// 日期选中背景颜色样式
  final Color daySelectedColor;

  /// 周末日期样式
  final Color weekendColor;

  /// 工作日日期样式
  final Color workDayColor;

  /// 周末日期样式
  final Color todayColor;

  /// 多选选中日期
  final List<DateTime> selectedDateTimes;

  CalendarList(
      {@required this.firstDate,
      @required this.lastDate,
      this.selectedType = CalendarSelectedType.Range,
      this.onSelectFinish,
      this.weekendColor = Colors.black,
      this.workDayColor = Colors.black,
      this.daySelectedColor = Colors.blue,
      this.selectedStartDate,
      this.todayColor = Colors.deepOrange,
      this.selectedDateTimes,
      this.selectedEndDate})
      : assert(firstDate != null),
        assert(lastDate != null),
        assert(!firstDate.isAfter(lastDate),
            'lastDate must be on or after firstDate');

  @override
  _CalendarListState createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  final double HORIZONTAL_PADDING = 25.0;
  DateTime selectStartTime;
  DateTime selectEndTime;
  int yearStart;
  int monthStart;
  int yearEnd;
  int monthEnd;
  int count;

  List<DateTime> selectedDateTimes = [];

  @override
  void initState() {
    super.initState();
    // 传入的开始日期
    selectStartTime = widget.selectedStartDate;
    // 传入的结束日期
    selectEndTime = widget.selectedEndDate;
    yearStart = widget.firstDate.year;
    monthStart = widget.firstDate.month;
    yearEnd = widget.lastDate.year;
    monthEnd = widget.lastDate.month;
    count = monthEnd - monthStart + (yearEnd - yearStart) * 12 + 1;
    selectedDateTimes = this.widget.selectedDateTimes ?? [];
  }

  // 选项处理回调
  void onSelectDayChanged(dateTime) {
    switch (this.widget.selectedType) {
      case CalendarSelectedType.Range:
        this.onRangeSelectedDate(dateTime);
        break;
      case CalendarSelectedType.Single:
        this.onSingleSelectedDate(dateTime);
        break;
      case CalendarSelectedType.Multiply:
        this.onMultiplySelectedDate(dateTime);
        break;
      default:
    }
  }

  /// 单选日期
  void onSingleSelectedDate(dateTime) {
    widget.onSelectFinish([dateTime]);
    setState(() {
      selectStartTime = dateTime;
    });
  }

  /// 多选日期
  void onMultiplySelectedDate(dateTime) {
    List<DateTime> datas = this.selectedDateTimes;
    if (datas.contains(dateTime)) {
      datas.remove(dateTime);
    } else {
      datas.add(dateTime);
    }
    setState(() {
      selectedDateTimes = datas;
    });
  }

  /// 多选日期
  void onRangeSelectedDate(dateTime) {
    DateTime start = selectStartTime;
    DateTime end = selectEndTime;
    if (selectStartTime == null && selectEndTime == null) {
      start = dateTime;
    } else if (selectStartTime != null && selectEndTime == null) {
      end = dateTime;
      // 如果选择的开始日期和结束日期相等，则清除选项
      if (selectStartTime == end) {
        setState(() {
          selectStartTime = null;
          selectEndTime = null;
        });
        return;
      }
      // 如果用户反选，则交换开始和结束日期
      if (selectStartTime.isAfter(end)) {
        DateTime temp = start;
        start = end;
        end = temp;
      }
    } else if (selectStartTime != null && selectEndTime != null) {
      // selectStartTime = null;
      end = null;
      start = dateTime;
    }
    widget.onSelectFinish([start, end]);
    setState(() {
      selectStartTime = start;
      selectEndTime = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 55.0,
              child: Container(
                padding: EdgeInsets.only(
                    left: HORIZONTAL_PADDING, right: HORIZONTAL_PADDING),
                decoration: BoxDecoration(
                  // border: Border.all(width: 3, color: Color(0xffaaaaaa)),
                  // 实现阴影效果
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2.0),
                        blurRadius: 1.0)
                  ],
                ),
                child: WeekdayRow(
                  weekendColor: this.widget.weekendColor,
                  workDayColor: this.widget.workDayColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 55.0, bottom: 50.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        int month = index + monthStart;
                        DateTime calendarDateTime = DateTime(yearStart, month);
                        return _getMonthView(calendarDateTime);
                      },
                      childCount: count,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMonthView(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    List<String> monthNames = [];
    for (int i = 1; i < 13; i++) {
      monthNames.add("${year}年${i}月");
    }
    return MonthView(
      selectedDateTimes: selectedDateTimes,
      daySelectedColor: this.widget.daySelectedColor,
      selectedType: this.widget.selectedType,
      context: context,
      year: year,
      month: month,
      monthNames: monthNames,
      padding: HORIZONTAL_PADDING,
      spacing: 5,
      dateTimeStart: selectStartTime,
      dateTimeEnd: selectEndTime,
      todayColor: this.widget.todayColor,
      onSelectDayRang: (dateTime) => onSelectDayChanged(dateTime),
    );
  }
}
