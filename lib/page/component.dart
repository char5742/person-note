import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CirclePersonIconBox extends StatelessWidget {
  final double? size;
  const CirclePersonIconBox({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _size = size ?? 72;
    return SizedBox(
      width: _size,
      height: _size,
      child: CircleAvatar(
          child: ClipOval(
        child: Stack(
          children: [
            Positioned(
              left: -_size / 6,
              child: Icon(
                Icons.person,
                size: _size * 4 / 3,
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class CustomMonthDayPicker extends DatePickerModel {
  CustomMonthDayPicker(
      {DateTime? currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [0, 1, 1];
  }
}
