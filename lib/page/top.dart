import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/provider/auth.dart';
import 'package:person_note/provider/person.dart';

import 'component.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget personCard(Person person) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,
          minHeight: 70,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.go('/detail?id=${person.id}'),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Really want to put a header icon.
                  const CirclePersonIconBox(size: 48),
                  const Padding(padding: EdgeInsets.only(left: 8.0)),
                  Column(children: [
                    Text(person.name, style: theme.textTheme.headlineSmall),
                    Row(
                      children: [
                        ...?person.tags?.map((e) => Card(child: Text(e)))
                      ],
                    ),
                  ]),
                ],
              ),
            ),
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
              padding: const EdgeInsets.only(top: 50),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    data.map(personCard).toList()[index],
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Container(
              child: Text(error.toString()),
            ),
          ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text(ref.watch(accountProvider)?.email ?? ''),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: () => ref.read(authProvider).signOut(),
                        child: const Text('sign out'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
