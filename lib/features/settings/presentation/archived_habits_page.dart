import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/confirm_sheet.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

final archivedHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(habitRepositoryProvider).watchArchived();
});

class ArchivedHabitsPage extends ConsumerWidget {
  const ArchivedHabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habits = ref.watch(archivedHabitsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.archivedHabits)),
      body: habits.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const AsyncErrorView(),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.noArchivedHabits));
          }
          return ResponsiveListView(
            side: 16,
            top: 8,
            bottom: 24,
            children: [
              for (final habit in items)
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8),
                  child: SoftCard(
                    child: Row(
                      children: [
                        Icon(
                          habitIcon(habit.icon),
                          color: habitColor(habit.colorKey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(habit.name)),
                        TextButton(
                          onPressed: () async {
                            final repository = ref.read(
                              habitRepositoryProvider,
                            );
                            await repository.unarchive(habit.id);
                            if (!context.mounted) return;
                            showUndoBar(
                              context,
                              message: l10n.restoredMessage,
                              actionLabel: l10n.undo,
                              onUndo: () => repository.archive(habit.id),
                            );
                          },
                          child: Text(l10n.unarchive),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
