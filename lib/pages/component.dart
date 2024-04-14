import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:person_note/utils/date_format.dart';
import 'package:person_note/utils/validator.dart' as validator;

class CirclePersonIconBox extends StatelessWidget {
  const CirclePersonIconBox({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        child: ClipOval(
          child: Stack(
            children: [
              Positioned(
                left: -size / 6,
                child: Icon(
                  Icons.person,
                  size: size * 4 / 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonForm extends StatelessWidget {
  const PersonForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.memoController,
    required this.birthdayController,
    required this.tagsController,
  });
  final Key formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController memoController;
  final ValueNotifier<DateTime?> birthdayController;
  final ValueNotifier<List<String>> tagsController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // name field
              _NameField(nameController: nameController),
              // age field
              _AgeField(ageController: ageController),
              // email field
              _EmailField(emailController: emailController),
              // birthday field
              const SizedBox(height: 16),
              _BirthdayField(birthday: birthdayController),
              // memo field
              _MemoField(memoController: memoController),
              // tags field
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16),
                child: _TagsField(tagsController: tagsController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.nameController});
  final TextEditingController nameController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      validator: validator.isNonNullString,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.name),
      ),
    );
  }
}

class _AgeField extends StatelessWidget {
  const _AgeField({required this.ageController});
  final TextEditingController ageController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ageController,
      validator: validator.isNumber,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.age),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.email),
      ),
    );
  }
}

class _BirthdayField extends StatelessWidget {
  const _BirthdayField({required this.birthday});
  final ValueNotifier<DateTime?> birthday;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.birthday,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(width: 16),
        Text(
          formatDate(birthday.value),
          style: theme.textTheme.bodyLarge,
        ),
        IconButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: birthday.value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            birthday.value = date;
          },
          icon: const Icon(Icons.date_range),
        ),
      ],
    );
  }
}

class _MemoField extends StatelessWidget {
  const _MemoField({required this.memoController});
  final TextEditingController memoController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: memoController,
      maxLines: null,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.memo),
      ),
      selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
    );
  }
}

class _TagsField extends StatelessWidget {
  const _TagsField({required this.tagsController});
  final ValueNotifier<List<String>> tagsController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.tags,
          style: theme.textTheme.labelLarge,
        ),
        ...tagsController.value.map(
          (e) => Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                e,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) {
                final controller = TextEditingController();
                return SimpleDialog(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    TextFormField(controller: controller),
                    IconButton(
                      onPressed: () {
                        tagsController.value = [
                          ...tagsController.value,
                          controller.text,
                        ];
                        context.pop();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class SelectActionDialog extends StatelessWidget {
  const SelectActionDialog({
    super.key,
    this.onDelete,
    this.onEdit,
    required this.deleteButtonLabel,
    required this.ediButtontLabel,
  });
  final void Function()? onDelete;
  final void Function()? onEdit;
  final String deleteButtonLabel;
  final String ediButtontLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              context.pop();
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.deleteCheck),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: onDelete,
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    ],
                  );
                },
              );
            },
            child: Row(
              children: [
                const Icon(Icons.delete, size: 28),
                const SizedBox(width: 10),
                Text(
                  deleteButtonLabel,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onEdit?.call();
            },
            child: Row(
              children: [
                const Icon(Icons.edit, size: 28),
                const SizedBox(width: 10),
                Text(
                  ediButtontLabel,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
