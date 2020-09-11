import 'package:flutter/material.dart';
import 'package:flutter_calendar/calendar_list.dart';
import 'package:flutter_calendar/calendar_notification.dart';

class DayNumber extends StatefulWidget {
  const DayNumber(
      {@required this.size,
      @required this.day,
      @required this.isDefaultSelected,
      this.daySelectedColor = Colors.blue,
      this.isToday,
      this.todayColor = Colors.blue,
      this.isFirst = false,
      this.isEnd = false,
      this.todayInRange = false,
      this.selectedType = CalendarSelectedType.Range});
  final CalendarSelectedType selectedType;
  final int day;
  final Color daySelectedColor;
  final bool isToday;
  final bool todayInRange;
  final Color todayColor;
  final double size;
  final bool isDefaultSelected;

  final bool isFirst;
  final bool isEnd;

  @override
  _DayNumberState createState() => _DayNumberState();
}

class _DayNumberState extends State<DayNumber> {
  final double itemMargin = 0;
  bool isSelected;
  bool isFirst;
  bool isEnd;

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
            : widget.isToday ? widget.todayColor : Colors.transparent,
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
        widget.isToday ? "今" : widget.day < 1 ? '' : widget.day.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: (widget.isToday || isSelected) ? Colors.white : Colors.black87,
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
    return widget.day > 0
        ? InkWell(
            onTap: () => CalendarNotification(widget.day).dispatch(context),
            child: _dayItem())
        : _dayItem();
  }
}
