import 'package:flutter/material.dart';

import '../../helpers/date_helper.dart';

class RecipeDates extends StatelessWidget {
    final int? timestampCreate;
    final int? timestampLastUpdate;
    final int? timestampLastExport;
    final int? timestampLastImport;

    const RecipeDates({
      Key? key,
      required this.timestampCreate,
      required this.timestampLastUpdate,
      required this.timestampLastExport,
      required this.timestampLastImport,
    }) : super(key: key);

    _dateSection(String label, String datetimeYMDHIS) {
      return Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(datetimeYMDHIS),
        ],
      );
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _dateSection(
                'Created on',
                timestampCreate != null ? formatTimestampToYMDHIS(timestampCreate!) : 'N/A',
              ),
              _dateSection(
                'Last Modified',
                timestampLastUpdate != null ? formatTimestampToYMDHIS(timestampLastUpdate!) : 'N/A',
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _dateSection(
                'Last Exported',
                timestampLastExport != null ? formatTimestampToYMDHIS(timestampLastExport!) : 'N/A',
              ),
              _dateSection(
                'Last Imported',
                timestampLastImport != null ? formatTimestampToYMDHIS(timestampLastImport!) : 'N/A',
              ),
            ],
          ),
        ],
      );
    }
}