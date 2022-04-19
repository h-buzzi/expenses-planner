import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Expenses with ChangeNotifier {
  final String id;
  final String itemName;
  final String descript;
  final double cost;
  final String category;
  final int day;

  Expenses(
      {required this.id,
      required this.itemName,
      this.descript = '',
      required this.cost,
      required this.day,
      required this.category});

  Expenses copyWith(
      {String? id,
      String? itemName,
      String? descript,
      double? cost,
      int? day,
      String? category}) {
    return Expenses(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        descript: descript ?? this.descript,
        cost: cost ?? this.cost,
        day: day ?? this.day,
        category: category ?? this.category);
  }

  Color returnCategoryColor(BuildContext context) {
    if (category == 'mandatory') {
      return Theme.of(context).primaryColor;
    } else if (category == 'meals') {
      return Theme.of(context).colorScheme.onTertiaryContainer;
    } else if (category == 'groceries') {
      return Theme.of(context).colorScheme.tertiaryContainer;
    } else if (category == 'learning') {
      return Theme.of(context).colorScheme.primaryContainer;
    } else if (category == 'leisure') {
      return Theme.of(context).colorScheme.secondaryContainer;
    } else if (category == 'others') {
      return Theme.of(context).colorScheme.outline;
    }
    return Theme.of(context).colorScheme.tertiary;
  }
}
