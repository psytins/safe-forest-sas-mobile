import 'package:flutter/material.dart';
import 'model/warning.dart';

class WarningLogPage extends StatefulWidget {
  @override
  _WarningLogPageState createState() => _WarningLogPageState();
}

class _WarningLogPageState extends State<WarningLogPage> {
  List<Warning> warnings = [
    Warning(
      cameraId: 'Camera 1',
      date: '2024-06-25',
      sensitivity: 'High',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Warning(
      cameraId: 'Camera 2',
      date: '2024-06-26',
      sensitivity: 'Medium',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warning Log'),
      ),
      body: ListView(
        children: warnings.map((warning) => WarningTile(warning: warning)).toList(),
      ),
    );
  }
}

class WarningTile extends StatefulWidget {
  final Warning warning;

  WarningTile({required this.warning});

  @override
  _WarningTileState createState() => _WarningTileState();
}

class _WarningTileState extends State<WarningTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _isExpanded,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Camera ID: ${widget.warning.cameraId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${widget.warning.date}'),
                    Text('Sensitivity: ${widget.warning.sensitivity}'), // Show sensitivity here
                  ],
                ),
              );
            },
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Image.network(widget.warning.imageUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
