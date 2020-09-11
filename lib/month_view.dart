import 'package:flutter/material.dart';
import 'package:flutter_calendar/calendar_list.dart';
import 'package:flutter_calendar/calendar_notification.dart';

import 'day_number.dart';
import 'month_title.dart';
import 'utils/dates.dart';
import 'utils/screen_sizes.dart';

class MonthView extends StatefulWidget {
  const MonthView({
    @required this.context,
    @required this.year,
    @required this.month,
    @required this.dateTimeStart,
    @required this.dateTimeEnd,
    @required this.onSelectDayRang,
    this.padding = 0,
    this.spacing = 0,
    this.todayColor,
    this.daySelectedColor = Colors.blue,
    this.monthNames,
    this.selectedDateTimes = const [],
    this.selectedType = CalendarSelectedType.Range,
  });

  ///日历选择模式
  final CalendarSelectedType selectedType;
  final BuildContext context;

  ///当前年
  final int year;

  ///当前月
  final int month;
  final double padding;

  ///月与月之间的间距
  final double spacing;

  ///今日背景颜色
  final Color todayColor;

  ///选中日期颜色
  final Color daySelectedColor;

  ///多选选中日期
  final List<DateTime> selectedDateTimes;

  ///自定义月份名称数组
  final List<String> monthNames;

  ///范围选择开始日期
  final DateTime dateTimeStart;

  ///范围选择结束日期
  final DateTime dateTimeEnd;

  ///范围日期
  final Function onSelectDayRang;

  double get itemWidth => getDayNumberSize(context, padding);

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  int rowCount = 5;
  DateTime selectedDate;

  @override
  void initState() {
    this.countDayRow();
    super.initState();
  }

  ///仅仅计算几行
  void countDayRow() {
    List<Row> dayRows = <Row>[];
    List<DayNumber> dayRowChildren = <DayNumber>[];

    int daysInMonth = getDaysInMonth(widget.year, widget.month);

    // 日 一 二 三 四 五 六
    int firstWeekdayOfMonth = DateTime(widget.year, widget.month, 2).weekday;

    for (int day = 2 - firstWeekdayOfMonth; day <= daysInMonth; day++) {
      dayRowChildren.add(
        DayNumber(
          size: widget.itemWidth,
          day: day,
          isToday: false,
          isDefaultSelected: false,
          todayColor: widget.todayColor,
        ),
      );

      if ((day - 1 + firstWeekdayOfMonth) % DateTime.daysPerWeek == 0 ||
          day == daysInMonth) {
        dayRows.add(
          Row(
            children: List<DayNumber>.from(dayRowChildren),
          ),
        );
        dayRowChildren.clear();
      }
    }
    setState(() {
      rowCount = dayRows.length;
    });
  }

  Widget buildMonthDays(BuildContext context) {
    List<Row> dayRows = <Row>[];
    List<DayNumber> dayRowChildren = <DayNumber>[];

    int daysInMonth = getDaysInMonth(widget.year, widget.month);

    // 日 一 二 三 四 五 六
    int firstWeekdayOfMonth = DateTime(widget.year, widget.month, 2).weekday;

    for (int day = 2 - firstWeekdayOfMonth; day <= daysInMonth; day++) {
      DateTime moment = DateTime(widget.year, widget.month, day);
      final bool isToday = dateIsToday(moment);

      bool isDefaultSelected = false;
      if (widget.dateTimeStart == null &&
          widget.dateTimeEnd == null &&
          selectedDate == null) {
        isDefaultSelected = false;
      }
      if (widget.dateTimeStart == selectedDate &&
          widget.dateTimeEnd == null &&
          selectedDate?.day == day &&
          day > 0) {
        isDefaultSelected = true;
      }
      bool isFirst = false;
      bool isEnd = false;
      CalendarSelectedType currentType = this.widget.selectedType;
      bool todayInRange = false;
      if (widget.dateTimeStart != null && widget.dateTimeEnd != null) {
        isDefaultSelected = (moment.isAtSameMomentAs(widget.dateTimeStart) ||
                    moment.isAtSameMomentAs(widget.dateTimeEnd)) ||
                moment.isAfter(widget.dateTimeStart) &&
                    moment.isBefore(widget.dateTimeEnd) &&
                    day > 0
            ? true
            : false;
        if (moment.isAtSameMomentAs(widget.dateTimeStart)) {
          isFirst = true;
        }
        if (moment.isAtSameMomentAs(widget.dateTimeEnd)) {
          isEnd = true;
        }
        if (moment.isAfter(widget.dateTimeStart) &&
            moment.isBefore(widget.dateTimeEnd) &&
            day > 0) {
          todayInRange = true;
        }
      } else {
        if (this.widget.selectedType == CalendarSelectedType.Multiply) {
          isDefaultSelected = this.widget.selectedDateTimes.contains(moment);
        }

        /// 只选择一个的时候还是显示圆形选择框
        currentType = CalendarSelectedType.Single;
      }

      dayRowChildren.add(
        DayNumber(
          daySelectedColor: this.widget.daySelectedColor,
          selectedType: currentType,
          size: widget.itemWidth,
          day: day,
          isFirst: isFirst,
          isEnd: isEnd,
          todayInRange: todayInRange,
          isToday: isToday,
          isDefaultSelected: isDefaultSelected,
          todayColor: widget.todayColor,
        ),
      );

      if ((day - 1 + firstWeekdayOfMonth) % DateTime.daysPerWeek == 0 ||
          day == daysInMonth) {
        dayRows.add(
          Row(
            children: List<DayNumber>.from(dayRowChildren),
          ),
        );
        dayRowChildren.clear();
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dayRows,
    );
  }

  Widget buildMonthView(BuildContext context) {
    return NotificationListener<CalendarNotification>(
        onNotification: (notification) {
          selectedDate =
              DateTime(widget.year, widget.month, notification.selectDay);
          widget.onSelectDayRang(selectedDate);
          return true;
        },
        child: Container(
          width: 7 * getDayNumberSize(context, widget.padding),
          margin: EdgeInsets.symmetric(horizontal: widget.padding),
          padding: EdgeInsets.symmetric(vertical: widget.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MonthTitle(
                month: widget.month,
                monthNames: widget.monthNames,
              ),
              SizedBox(height: 5),
              Stack(
                children: [
                  Container(
                    width: widget.itemWidth * 7,
                    height: widget.itemWidth * rowCount,
                    child: Center(
                      child: Text(
                        this.widget.month.toString(),
                        style: TextStyle(
                            color: Colors.black12,
                            fontSize: 200,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0),
                      child: buildMonthDays(context),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildMonthView(context),
    );
  }
}
