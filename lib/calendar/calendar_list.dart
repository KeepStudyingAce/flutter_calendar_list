library calendar_list;

import 'package:flutter/material.dart';

import './view/month_view.dart';
import './view/weekday_row.dart';

const arrowLeft = "lib/images/arrow_left.png";
const arrowRight = "lib/images/arrow_right.png";

/// 单选多选和范围选择
enum CalendarSelectedType { Single, Multiply, Range }

/// 日历显示类型，ListView滚动类型、PageView翻页类型
enum CalendarDisplayType { ListView, PageView }

class CalendarList extends StatefulWidget {
  /// 日历最早日期
  final DateTime firstDate;

  /// 日历最晚日期
  final DateTime lastDate;

  /// 日历选中开始日期/间隔开始日期
  final DateTime selectedStartDate;

  /// 日历间隔天数
  final int dayInterval;

  /// 选中天数次数
  final int dayTimes;

  /// 日历选中结束日期
  final DateTime selectedEndDate;

  /// 日历选中结果回调
  final Function(List<DateTime>) onSelectFinish;

  /// 日历选择模式
  final CalendarSelectedType selectedType;

  /// 日历展示类型
  final CalendarDisplayType displayType;

  /// 日期选中背景颜色样式
  final Color daySelectedColor;

  /// 周末日期样式
  final Color weekendColor;

  /// 工作日日期样式
  final Color workDayColor;

  /// 今天日期样式
  final Color todayColor;

  /// 是否隐藏月份头部
  final bool hideMonthHeader;

  /// 日历高度
  final double height;

  /// 多选选中日期
  final List<DateTime> selectedDateTimes;

  CalendarList(
      {@required this.firstDate,
      @required this.lastDate,
      this.height,
      this.selectedType = CalendarSelectedType.Range,
      this.onSelectFinish,
      this.dayInterval = 0,
      this.dayTimes = 0,
      this.weekendColor = Colors.black,
      this.workDayColor = Colors.black,
      this.daySelectedColor = Colors.blue,
      this.selectedStartDate,
      this.todayColor = Colors.blue,
      this.selectedDateTimes,
      this.hideMonthHeader = false,
      this.displayType = CalendarDisplayType.PageView,
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
  PageController _pageController;
  int currentMonth;
  int currentPage;
  List<DateTime> selectedDateTimes = [];
  String currentYearMonth = "";

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
    currentMonth = DateTime.now().month;
    currentPage =
        currentMonth - monthStart + (DateTime.now().year - yearStart) * 12;
    selectedDateTimes = this.widget.selectedDateTimes ?? [];
    _pageController = PageController(initialPage: currentPage);
    currentYearMonth = "${DateTime.now().year}年${DateTime.now().month}月";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.widget.height,
      child: this.widget.displayType == CalendarDisplayType.ListView
          ? _buildListViewCalender()
          : _buildPageViewCalendar(),
    );
  }

  List<DateTime> selectDate() {
    List<DateTime> listTimes = [];
    if (this.widget.dayInterval > 0 && this.widget.dayTimes > 0) {
      listTimes.add(this.widget.selectedStartDate);
      listTimes.addAll(List.generate(this.widget.dayTimes - 1, (index) {
        return DateTime(
            this.widget.selectedStartDate.year,
            this.widget.selectedStartDate.month,
            this.widget.selectedStartDate.day +
                this.widget.dayInterval * (index + 1));
      }));
    }
    return listTimes;
  }

  Widget _buildListViewCalender() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
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
        // ),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    int month = index + monthStart; //月会溢出
                    DateTime calendarDateTime = DateTime(yearStart, month);
                    int year = calendarDateTime.year;
                    int monthNew = calendarDateTime.month; //重新获取加法之后的月份

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
                      month: monthNew,
                      monthNames: monthNames,
                      padding: HORIZONTAL_PADDING,
                      spacing: 5,
                      dateTimeStart: selectStartTime,
                      dateTimeEnd: selectEndTime,
                      todayColor: this.widget.todayColor,
                      onSelectDayRang: (dateTime) =>
                          onSelectDayChanged(dateTime),
                    );
                  },
                  childCount: count,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageViewCalendar() {
    selectedDateTimes = this.selectDate();
    return Column(
      children: [
        Container(
          height: 50,
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
        Container(
            height: 50,
            padding: EdgeInsets.only(
                left: HORIZONTAL_PADDING, right: HORIZONTAL_PADDING),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentPage - 1 >= 0) {
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    }
                  },
                  child: Image.asset(arrowLeft),
                ),
                Text(
                  "$currentYearMonth",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (currentPage + 1 < count) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    }
                  },
                  child: Image.asset(arrowRight),
                ),
              ],
            )),
        Expanded(
          child: PageView.builder(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              int month = index + monthStart;
              DateTime calendarDateTime = DateTime(yearStart, month);
              int year = calendarDateTime.year;
              int monthNew = calendarDateTime.month;
              setState(() {
                currentPage = _pageController.page.ceil();
                currentYearMonth = "${year}年${monthNew}月";
              });
            },
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              int month = index + monthStart;
              DateTime calendarDateTime = DateTime(yearStart, month);
              int year = calendarDateTime.year;
              int monthNew = calendarDateTime.month; //重新获取加法之后的月份
              List<String> monthNames = [];
              return MonthView(
                selectedDateTimes: selectedDateTimes,
                daySelectedColor: this.widget.daySelectedColor,
                selectedType: this.widget.selectedType,
                context: context,
                hideMonthHeader: true,
                year: year,
                month: monthNew,
                monthNames: monthNames,
                padding: HORIZONTAL_PADDING,
                spacing: 5,
                dateTimeStart: selectStartTime,
                dateTimeEnd: selectEndTime,
                todayColor: this.widget.todayColor,
                onSelectDayRang: (dateTime) => onSelectDayChanged(dateTime),
              );
            },
          ),
        )
      ],
    );
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
}
