import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

void showLogDetailsDialog({
  required BuildContext context,
  required FlutoLogModel flutoLog,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(flutoLog.logType.name.toString()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                const Text(
                  "Message:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(flutoLog.logMessage),
              ],
              if (flutoLog.logType == FlutoLogType.error) ...[
                const SizedBox(height: 10),
                const Text(
                  "Stack Trace:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(flutoLog.getFormattedError),
                const SizedBox(height: 10),
              ],
              const Text(
                "Timestamp:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(flutoLog.getFormattedLogTime.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
