import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:pill_reminder/db/schedules_helper.dart';
import 'package:pill_reminder/model/dashboard.dart';
import 'package:pill_reminder/notification_helper.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  List<Dashboard> listToShow = [];

  @override
  void initState() {
    super.initState();

    SchedulesHelper.getSchedulesToday(
            DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .then((value) {
      setState(() {
        listToShow = value;
      });
/*      for (Dashboard element in value) {
        DateTime dtt = DateFormat('dd/MM/yyyy HH:mm aa')
            .parse('${element.date} ${element.time}');

        print(dtt);
        List<DashboardItem>? items = element.items;
        for (var it in items!) {
          print('${it.name} ${it.dose}');
        }
        
      }
      */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: listToShow.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: makeCard(listToShow[index]),
            );
          }),
    );
  }

  int indx = 0;
  Card makeCard(Dashboard dashboard) => Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 5.0, color: Color.fromARGB(59, 246, 238, 238)))),
          child: makeListTile(dashboard),
        ),
      );

  ListTile makeListTile(Dashboard dashboard) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
              ),
              Text(
                toBeginningOfSentenceCase(dashboard.time) ?? "",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(color: Colors.white, height: 15, thickness: 0.7),
          for (int i = 0; i < dashboard.items!.length; i++)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Card(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            toBeginningOfSentenceCase(
                                    dashboard.items![i].name) ??
                                '',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          )),
                      Divider(
                        color: Colors.white,
                      ),
                      Row(children: [
                        Container(
                            padding: EdgeInsets.only(left: 15, bottom: 10),
                            child: Text(
                              toBeginningOfSentenceCase(
                                      dashboard.items![i].dose) ??
                                  '',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            )),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(
                            right: 15,
                            bottom: 10,
                          ),
                          child: GFCheckbox(
                            size: GFSize.SMALL,
                            activeBgColor: Colors.green,
                            type: GFCheckboxType.circle,
                            onChanged: (value) {
                              setState(() {
                                dashboard.items![i].status = 'TAKEN';
                              });
                            },
                            value: (dashboard.items![i].status == 'TAKEN'),
                            inactiveIcon: null,
                          ),
                        )
                      ]), ///////////////
                    ],
                  ),
                ))
        ]),
        onTap: () {},
      );
}
