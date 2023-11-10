import 'package:flutter/material.dart';
import 'package:pill_reminder/prescriptionaddstep1.dart';

class PrescriptionWidget extends StatefulWidget {
  const PrescriptionWidget({super.key});

  @override
  State<PrescriptionWidget> createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPrescriptionStepOneWidget()));

          //if (refresh) dataRefresh();
        },
        child: Icon(Icons.add),
      ),
      body: Container(),
    );
  }
}
