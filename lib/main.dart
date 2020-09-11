import 'package:flutter/material.dart';

import 'calendar_list.dart';

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

  @override
  void initState() {
    con = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("列表型日历"),
      ),
      body: Column(
        children: [
          TabBar(
            controller: con,
            tabs: ["单选", "多选", "范围选择"].map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black45,
          ),
          Expanded(
              child: TabBarView(controller: con, children: [
            CalendarList(
              weekendColor: Colors.amber,
              selectedType: CalendarSelectedType.Single,
              firstDate: DateTime(2020, 8),
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
