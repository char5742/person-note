import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/providers/event_provider.dart';
import 'package:person_note/providers/person_provider.dart';
import 'package:person_note/utils/date_format.dart';

import '../component.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({required this.personId, super.key});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final person = ref.watch(personByIdProvider(personId)).value!;
    final theme = Theme.of(context);

    final personAgeText = person.age != null
        ? AppLocalizations.of(context)!.yearsOld(person.age!)
        : '';
    final birthday = AppLocalizations.of(context)!.birthday;
    final personBirthdayText = person.birthday != null
        ? '$birthday ${formatDate(person.birthday)}'
        : '';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/detail/create_event?id=$personId'),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(person.name),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CirclePersonIconBox(),
                      ElevatedButton(
                        onPressed: () =>
                            context.go('/detail/edit?id=$personId'),
                        child: Text(AppLocalizations.of(context)!.editNote),
                      )
                    ],
                  ),
                  Text(person.email ?? '', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(person.memo, style: theme.textTheme.bodyLarge),
                  Text(
                    '$personAgeText  $personBirthdayText',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          EventList(personId: personId),
        ],
      ),
    );
  }
}

class EventList extends HookConsumerWidget {
  const EventList({required this.personId, super.key});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // the new one come on top
    final eventAsync = ref.watch(
      eventByPersonIdProvider(personId).select(
        (data) => data
          ..asData?.value.sort((a, b) => b.dateTime.compareTo(a.dateTime)),
      ),
    );
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return eventAsync.when(
      error: (e, s) =>
          SliverList(delegate: SliverChildListDelegate([Container()])),
      loading: () => SliverList(
        delegate: SliverChildListDelegate([const CircularProgressIndicator()]),
      ),
      data: (eventList) => SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: eventList.length,
          (context, index) {
            final event = eventList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDateTime(event.dateTime)),
                            Text(
                              event.text,
                              style: textTheme.bodyLarge,
                            ),
                            Wrap(
                              children: [
                                ...?event.personIdList?.map(
                                  EventCard.new,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        builder: (context) => SelectActionDialog(
                          deleteButtonLabel:
                              AppLocalizations.of(context)!.addEvent,
                          ediButtontLabel:
                              AppLocalizations.of(context)!.editEvent,
                          onDelete: () => ref
                              .read(eventServiceProvider)
                              .removeEvent(event.id)
                              .then((value) => context.pop()),
                          onEdit: () => context.go(
                              '/detail/edit_event?id=${event.personIdList?.first}'
                              '&event_id=${event.id}'),
                        ),
                      ),
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EventCard extends HookConsumerWidget {
  const EventCard(this.personId, {super.key});
  final String personId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(personByIdProvider(personId));
    return person.map(
      data: (data) => Card(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CirclePersonIconBox(
              size: 16,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                data.value.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      error: (_) => Container(),
      loading: (_) => const CircularProgressIndicator(),
    );
  }
}
