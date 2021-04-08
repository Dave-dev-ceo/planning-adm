
import 'package:flutter/foundation.dart';

class InvolucradosList {
final List<dynamic> involucradosList;

InvolucradosList(
  {
    @required this.involucradosList
  }
);

factory InvolucradosList.fromJson(List<dynamic> json) {
  return InvolucradosList(
    involucradosList: json
    );
}
}
