import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';

class DetailPage extends HookConsumerWidget {
  final String personId;
  const DetailPage({required this.personId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(personByIdProvider(personId)).isLoading) {
      return const CircularProgressIndicator();
    }
    final person = ref.watch(personByIdProvider(personId)).value!;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(person.id.toString()),
            Text(person.name),
            Text(person.age.toString()),
            Text(formatDate(person.birthday)),
            Text(person.email ?? ''),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...?person.tags?.map((e) =>
                    Padding(padding: const EdgeInsets.all(8.0), child: Text(e)))
              ],
            ),
            Text(person.updated.toIso8601String()),
            Text(person.created.toIso8601String()),
            ElevatedButton(
                onPressed: () {
                  ref.read(personProvider).removePerson(person.id);
                  context.go('/');
                },
                child: const Text("Delete"))
          ],
        ),
      ),
    );
  }
}
