import 'package:flutter/material.dart';
import '../calendar_list.dart';
import '../utils/calendar_notification.dart';

class DayNumber extends StatefulWidget {
  const DayNumber(
      {@required this.size,
      @required this.day,
      @required this.isDefaultSelected,
      this.daySelectedColor = Colors.blue,
      this.dayOtherSelectedColor = Colors.orangeAccent,
      this.isToday,
      this.isOtherSelected = false,
      this.todayColor = Colors.blue,
      this.isFirst = false,
      this.enabled = true,
      this.isEnd = false,
      this.showToday = true,
      this.todayInRange = false,
      this.selectedType = CalendarSelectedType.Range});

  /// 日期选择模式
  final CalendarSelectedType selectedType;
  final int day;

  /// 选中日期的背景色
  final Color daySelectedColor;

  /// 其他选中日期的背景色
  final Color dayOtherSelectedColor;

  /// 是否是今天
  final bool isToday;

  /// 是否可以选中
  final bool enabled;

  /// 今天颜色
  final Color todayColor;

  /// 大小
  final double size;

  /// 是否选中
  final bool isDefaultSelected;

  /// 是否根据日期选中
  final bool isOtherSelected;
  /*
  * 范围选择模式
  */
  /// 范围选择模式时的第一个和最后一个
  final bool isFirst;
  final bool isEnd;

  /// 范围选择是否包含今天
  final bool todayInRange;

  /// 是否显示今天
  final bool showToday;

  @override
  _DayNumberState createState() => _DayNumberState();
}

class _DayNumberState extends State<DayNumber> {
  final double itemMargin = 0;
  bool isSelected;
  bool isFirst;
  bool isEnd;
  bool showToday;

  Widget _dayItem() {
    bool isSingle = this.widget.selectedType != CalendarSelectedType.Range;
    return Container(
      width: widget.size - itemMargin * 2,
      height: widget.size - itemMargin * 2,
      margin: EdgeInsets.all(itemMargin),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (isSelected && widget.day > 0)
            ? widget.daySelectedColor
            : (widget.isOtherSelected && widget.day > 0)
                ? widget.dayOtherSelectedColor
                : (widget.isToday && showToday)
                    ? widget.todayColor
                    : Colors.transparent,
        borderRadius: (isSingle || (widget.isToday && !widget.todayInRange))
            ? BorderRadius.all(
                Radius.circular((widget.size - itemMargin * 2) / 2))
            : BorderRadius.only(
                topLeft: Radius.circular(
                    isFirst ? (widget.size - itemMargin * 2) / 2 : 0),
                topRight: Radius.circular(
                    isEnd ? (widget.size - itemMargin * 2) / 2 : 0),
                bottomLeft: Radius.circular(
                    isFirst ? (widget.size - itemMargin * 2) / 2 : 0),
                bottomRight: Radius.circular(
                    isEnd ? (widget.size - itemMargin * 2) / 2 : 0),
              ),
      ),
      child: Text(
        (widget.isToday && showToday)
            ? "今"
            : widget.day < 1 ? '' : widget.day.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ((widget.isToday && showToday) || isSelected)
              ? Colors.white
              : !widget.enabled ? Colors.grey : Colors.black87,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isSelected = widget.isDefaultSelected;
    isFirst = widget.isFirst;
    isEnd = widget.isEnd;
    showToday = widget.showToday;
    return widget.day > 0
        ? GestureDetector(
            onTap: () {
              if (widget.enabled) {
                CalendarNotification(widget.day).dispatch(context);
              }
            },
            child: _dayItem())
        : _dayItem();
  }
}
