import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';

Widget characterCard(int index, Document doc, BuildContext context) {
  List<Widget> row = [];
  if (doc["image"] != null) {
    row.add(
      SizedBox(
        width: 200.0,
        height: 200.0,
        child: Image.network(
          doc["image"],
        ),
      ),
    );
  }
  List<Widget> column = [];
  if (doc["name"] != null) {
    column.add(
      Text(
        doc["name"],
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }
  _addTextForField("Gender", doc, column);
  _addTextForField("Status", doc, column);
  _addTextForField("Last Location", doc, column);
  row.add(
    Flexible(
      child: Column(
        children: column,
      ),
    ),
  );
  return Card(
    child: Row(
      children: row,
    ),
  );
}

void _addTextForField(fieldName, Document doc, List<Widget> column) {
  if (doc[fieldName] != null) {
    column.add(
      Text(
        "$fieldName: ${doc[fieldName]}",
        textAlign: TextAlign.left,
        softWrap: true,
      ),
    );
  }
}
