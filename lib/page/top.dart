import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/person.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget personCard(Person person) {
      return SizedBox(
        width: 200,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.go('/detail?id=${person.id}'),
            child: Column(children: [
              Text(person.name, style: theme.textTheme.headlineSmall),
              Row(
                children: person.tags.map((e) => Card(child: Text(e))).toList(),
              ),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/create'),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ref.watch(personListProvider).when(
            data: (data) => Container(
              padding: const EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Column(
                children: data.map(personCard).toList(),
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Container(
              child: Text(error.toString()),
            ),
          ),
    );
  }
}
