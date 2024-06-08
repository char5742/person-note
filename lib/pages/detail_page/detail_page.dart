import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/providers/event_provider.dart';
import 'package:person_note/providers/good_point_provider.dart';
import 'package:person_note/providers/person_provider.dart';
import 'package:person_note/utils/date_format.dart';

import '../component.dart';

enum DetailPageTab { event, goodPoint }

class DetailPage extends HookConsumerWidget {
  const DetailPage({
    required this.personId,
    required this.tab,
    super.key,
  });
  final String personId;
  final DetailPageTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/person/$personId/${tab.name}/create'),
        child: const Icon(Icons.add),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, bodyIsScrolled) => [
          _PersonNameHeader(personId: personId),
          _PersonDetail(personId: personId),
          SliverAppBar(
            bottom: TabBar(
              onTap: (int index) {
                final tab = DetailPageTab.values[index];
                context.go('/person/$personId?tab=${tab.name}');
              },
              controller: tabController,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.event),
                Tab(text: AppLocalizations.of(context)!.goodPoint),
              ],
            ),
            pinned: true,
            toolbarHeight: 0,
            automaticallyImplyLeading: false,
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            _EventList(personId: personId),
            _GoodPointList(personId: personId),
          ],
        ),
      ),
    );
  }
}

class _PersonNameHeader extends HookConsumerWidget {
  const _PersonNameHeader({required this.personId});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personByIdProvider(personId));
    return personAsync.when(
      data: (person) => SliverAppBar(
        pinned: true,
        title: Text(person.name),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => SliverToBoxAdapter(
        child: Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}

class _PersonDetail extends HookConsumerWidget {
  const _PersonDetail({required this.personId});
  final String personId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personByIdProvider(personId));
    final theme = Theme.of(context);
    return personAsync.when(
      data: (person) {
        final personAgeText = person.age != null
            ? AppLocalizations.of(context)!.yearsOld(person.age!)
            : '';
        final birthday = AppLocalizations.of(context)!.birthday;
        final personBirthdayText = person.birthday != null
            ? '$birthday ${formatDate(person.birthday)}'
            : '';
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CirclePersonIconBox(),
                    ElevatedButton(
                      onPressed: () => context.go('/person/$personId/edit'),
                      child: Text(AppLocalizations.of(context)!.editNote),
                    ),
                  ],
                ),
                Text(person.email ?? '', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(person.memo, style: theme.textTheme.bodyLarge),
                Text(
                  '$personAgeText  $personBirthdayText',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => SliverToBoxAdapter(
        child: Center(child: Text(e.toString())),
      ),
    );
  }
}

class _GoodPointList extends HookConsumerWidget {
  const _GoodPointList({required this.personId});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodPointAsync = ref.watch(
      goodPointListProvider(personId).select(
        (data) => data
          ..asData?.value.sort((a, b) => b.created!.compareTo(a.created!)),
      ),
    );
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return goodPointAsync.when(
      error: (e, s) => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      data: (goodPointList) => ListView.builder(
        itemCount: goodPointList.length,
        itemBuilder: (context, index) {
          final goodPoint = goodPointList[index];
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
                          Text(formatDateTime(goodPoint.created)),
                          Text(
                            goodPoint.point,
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      builder: (context) => SelectActionDialog(
                        deleteButtonLabel:
                            AppLocalizations.of(context)!.deleteGoodPoint,
                        ediButtontLabel:
                            AppLocalizations.of(context)!.editGoodPoint,
                        onDelete: () => ref
                            .read(goodPointServiceProvider(personId))
                            .removeGoodPoint(goodPoint.id)
                            .then((value) => context.pop()),
                        onEdit: () => context.go(
                          '/person/$personId/good_point/${goodPoint.id}/edit',
                        ),
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
    );
  }
}

class _EventList extends HookConsumerWidget {
  const _EventList({required this.personId});
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
      error: (e, s) => Text(e.toString()),
      loading: () => const CircularProgressIndicator(),
      data: (eventList) => ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
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
                                _EventCard.new,
                              ),
                            ],
                          ),
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
                          '/person/${event.personIdList?.first}/event/${event.id}/edit',
                        ),
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
    );
  }
}

class _EventCard extends HookConsumerWidget {
  const _EventCard(this.personId, {super.key});
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
