import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/app.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';

import 'component.dart';

class DetailPage extends HookConsumerWidget {
  final String personId;
  const DetailPage({required this.personId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(personByIdProvider(personId)).isLoading) {
      return const CircularProgressIndicator();
    }
    final person = ref.watch(personByIdProvider(personId)).value!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CirclePersonIconBox(),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Edit Note'))
                  ],
                ),
                Text(person.email ?? '', style: theme.textTheme.bodyMedium),
                const Padding(padding: EdgeInsets.only(top: 8.0)),
                Text(person.memo, style: theme.textTheme.bodyLarge),
                Text(
                    '${person.age != null ? "${person.age}歳" : ""}  ${person.birthday != null ? "誕生日: ${person.birthday?.month}月${person.birthday?.day}日" : ""}',
                    style: theme.textTheme.bodyLarge),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 1000,
                  width: 200,
                  alignment: Alignment.topLeft,
                ),
              ],
            ),
          ),
        ],
      ),
      //     Center(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(person.id.toString()),
      //       Text(person.name),
      //       Text((person.age ?? '').toString()),
      //       Text(formatDate(person.birthday)),
      //       Text(person.email ?? ''),
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           ...?person.tags?.map((e) =>
      //               Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))
      //         ],
      //       ),
      //       Text(person.updated.toIso8601String()),
      //       Text(person.created.toIso8601String()),
      //       ElevatedButton(
      //           onPressed: () {
      //             ref.read(personProvider).removePerson(person.id);
      //             context.go('/');
      //           },
      //           child: const Text("Delete"))
      //     ],
      //   ),
      // ),
    );
  }
}
