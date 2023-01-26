import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/util/date_format.dart';
import 'package:person_note/util/validator.dart';

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

class PersonForm extends HookConsumerWidget {
  final Key formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController memoController;
  final ValueNotifier<DateTime?> birthday;
  final ValueNotifier<List<String>> tags;

  const PersonForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.memoController,
    required this.birthday,
    required this.tags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: Validator.isNonNullString,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.name)),
              ),
              TextFormField(
                controller: ageController,
                validator: Validator.isNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.age)),
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.email)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.birthday,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      formatDate(birthday.value),
                      style: theme.textTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: () async {
                        final date = await DatePicker.showPicker(
                          context,
                          pickerModel:
                              CustomMonthDayPicker(currentTime: DateTime(0)),
                        );
                        birthday.value = date;
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: memoController,
                maxLines: null,
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.memo)),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.tags,
                        style: theme.textTheme.labelLarge),
                    ...tags.value.map((e) => Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            e,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ))),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return SimpleDialog(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              children: [
                                TextFormField(controller: controller),
                                IconButton(
                                  onPressed: () {
                                    tags.value = [
                                      ...tags.value,
                                      controller.text
                                    ];
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
