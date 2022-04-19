import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  String category;
  final Color colorCategory;
  final Function submitCategory;
  CategoryButton(
      {required this.category,
      required this.colorCategory,
      required this.submitCategory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: OutlinedButton(
        onPressed: () {
          submitCategory(category);
        },
        style: OutlinedButton.styleFrom(side: BorderSide(color: colorCategory)),
        child: Text(
          category,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: colorCategory, fontSize: 15),
        ),
      ),
    );
  }
}
