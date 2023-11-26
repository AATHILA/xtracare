import 'package:flutter/material.dart';
import 'package:pill_reminder/api/sync_data_from_server.dart';
import 'package:pill_reminder/api/sync_data_to_server.dart';

class SyncDataWidget extends StatefulWidget {
  const SyncDataWidget({super.key});

  @override
  State<SyncDataWidget> createState() => _SyncDataWidgetState();
}

class _SyncDataWidgetState extends State<SyncDataWidget> {
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    dataRefresh();
  }

  dataRefresh() async {
    await SyncDataFromServer.syncDataFromServer();
    await SyncDataToServer.syncDataToServer();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : const Center(
            child: Text('Manual Sync Completed'),
          );
  }
}
