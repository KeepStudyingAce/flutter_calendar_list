import 'package:flutter/material.dart';

import 'calendar/calendar_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '列表型日历选择组件',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin<MyHomePage> {
  TabController con;
  int label = 7;

  DateTime temp;

  @override
  void initState() {
    con = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("列表型日历"),
      ),
      body: Column(
        children: [
          TabBar(
            controller: con,
            tabs: ["间隔选择", "单选", "多选", "范围选择"].map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black45,
          ),
          Expanded(
              child: TabBarView(controller: con, children: [
            Column(
              children: [
                Expanded(
                  child: CalendarList(
                    showToday: false,
                    dayInterval: label ?? 0,
                    dayTimes: 10,
                    weekendColor: Colors.amber,
                    selectedStartDate: temp ?? DateTime(2020, 8, 20),
                    selectedType: CalendarSelectedType.Single,
                    displayType: CalendarDisplayType.PageView,
                    firstDate: DateTime(2020, 1),
                    lastDate: DateTime(2021, 12),
                    onSelectFinish: (List<DateTime> dates) {
                      List<DateTime> result = <DateTime>[];
                      result.addAll(dates);
                      setState(() {
                        temp = result.first;
                      });
                      print("间隔单选中日期$result");
                    },
                  ),
                ),
                Text("间隔：" + (label.toString() ?? "")),
                Wrap(
                  children: List.generate(6, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          label = index;
                        });
                      },
                      child: Container(
                        color: Colors.amber,
                        width: 40,
                        height: 30,
                        child: Center(
                          child: Text(
                            index.toString(),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
              ],
            ),
            CalendarList(
              weekendColor: Colors.amber,
              selectedType: CalendarSelectedType.Single,
              displayType: CalendarDisplayType.PageView,
              firstDate: DateTime(2020, 1),
              lastDate: DateTime(2021, 12),
              onSelectFinish: (List<DateTime> dates) {
                List<DateTime> result = <DateTime>[];
                result.addAll(dates);
                print("单选中日期$result");
              },
            ),
            CalendarList(
              weekendColor: Colors.amber,
              selectedType: CalendarSelectedType.Multiply,
              firstDate: DateTime(2020, 8),
              displayType: CalendarDisplayType.ListView,
              lastDate: DateTime(2021, 12),
              onSelectFinish: (List<DateTime> dates) {
                List<DateTime> result = <DateTime>[];
                result.addAll(dates);
                print("多选中日期$result");
              },
            ),
            CalendarList(
              weekendColor: Colors.amber,
              selectedType: CalendarSelectedType.Range,
              displayType: CalendarDisplayType.ListView,
              firstDate: DateTime(2020, 8),
              lastDate: DateTime(2021, 12),
              onSelectFinish: (List<DateTime> dates) {
                List<DateTime> result = <DateTime>[];
                result.addAll(dates);
                print("范围选择日期$result");
              },
            )
          ]))
        ],
      ),
    );
  }
}
