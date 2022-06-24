import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:web_rtc_template/constants/funcs.dart';
import 'package:web_rtc_template/constants/vars.dart';

class CustomDatePickerCard extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDate;

  const CustomDatePickerCard({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Vars.listTilePadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(kRadialReactionRadius),
      ),
      child: ListTile(
        leading: const Icon(Icons.date_range_outlined),
        minLeadingWidth: 0,
        title: ValueListenableBuilder(
          valueListenable: selectedDate,
          builder: (ctx, DateTime? value, child) {
            if (value == null) {
              return const Text("Select birthdate", style: TextStyle(color: Colors.grey));
            }
            else {
              return Text(Funcs.convertDateTimeToString(dateTime: value));
            }
          },
        ),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendar,
            initialDatePickerMode: DatePickerMode.year,
            initialDate: selectedDate.value ?? DateTime.utc(2000, 01, 01),
            firstDate: DateTime.utc(1950, 01, 01),
            lastDate: DateTime.now().add(const Duration(days: -365 * 18)),
          );
          if (pickedDate != null) {
            selectedDate.value = pickedDate;
            log(Funcs.convertDateTimeToString(dateTime: selectedDate.value!), name: "Selected Date");
          }
        },
      ),
    );
  }
}
