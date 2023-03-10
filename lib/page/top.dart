import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  Future<void> bottomSheet(context,
      {Function()? onDelete, Function()? onEdit}) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                  showDialog(
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
                      AppLocalizations.of(context)!.deleteNote,
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
                      AppLocalizations.of(context)!.editNote,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget personCard(Person person) {
      return Container(
        constraints: const BoxConstraints(
          minHeight: 70,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.go('/detail?id=${person.id}'),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Really want to put a header icon.
                        const CirclePersonIconBox(size: 48),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                person.name,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineSmall,
                              ),
                              Wrap(
                                children: [
                                  ...?person.tags?.map((e) => Card(
                                      child: Text(e,
                                          overflow: TextOverflow.ellipsis)))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => bottomSheet(
                    context,
                    onDelete: () => ref
                        .read(personProvider)
                        .removePerson(person.id)
                        .then((value) => context.pop()),
                    onEdit: () => context.go('/detail/edit?id=${person.id}'),
                  ),
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ],
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
            loading: () => const Center(child: CircularProgressIndicator()),
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
