import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/platform/reminder_picker.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit_templates.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_gate.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _page = PageController();
  final _picked = <String>{};
  var _index = 0;
  var _busy = false;
  int? _reminder;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: _busy ? null : _finish, child: Text(l10n.skip)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (index) => setState(() => _index = index),
                children: [
                  _Welcome(scheme: scheme),
                  _Picker(picked: _picked, onToggle: _toggle),
                  _ReminderStep(
                    reminder: _reminder,
                    onPick: () async {
                      final picked = await showReminderPicker(
                        context,
                        currentMinutes: _reminder,
                      );
                      if (picked == null) return;
                      setState(() => _reminder = picked);
                    },
                    onClear: () => setState(() => _reminder = null),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var dot = 0; dot < 3; dot++)
                  AnimatedContainer(
                    duration: tokens.motion(context, tokens.motionFast),
                    margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: 4,
                    ),
                    width: dot == _index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dot == _index
                          ? scheme.primary
                          : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
              child: Row(
                children: [
                  if (_index > 0)
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => _page.previousPage(
                              duration: tokens.motion(
                                context,
                                tokens.motionMedium,
                              ),
                              curve: tokens.easeOut,
                            ),
                      child: Text(l10n.cancel),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _busy
                        ? null
                        : () {
                            if (_index < 2) {
                              _page.nextPage(
                                duration: tokens.motion(
                                  context,
                                  tokens.motionMedium,
                                ),
                                curve: tokens.easeOut,
                              );
                              return;
                            }
                            _finish();
                          },
                    child: Text(
                      _index == 2 ? l10n.getStarted : l10n.continueAction,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(String id) {
    setState(() {
      if (_picked.contains(id)) {
        _picked.remove(id);
      } else {
        _picked.add(id);
      }
    });
  }

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final start = CalendarDate.today().iso;
    for (final template in habitTemplates) {
      if (!_picked.contains(template.id)) continue;
      await ref
          .read(habitRepositoryProvider)
          .create(
            draftFromTemplate(
              l10n,
              template,
              startDate: start,
              reminderTime: _reminder,
            ),
          );
      if (!mounted) return;
    }
    ref.read(onboardingFlagProvider.notifier).markFinished();
    await ref
        .read(preferencesControllerProvider.notifier)
        .setOnboardingDone(true);
    if (!mounted) return;
    context.go('/today');
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(22),
              child: Icon(
                Icons.spa_outlined,
                size: 40,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.welcomeTitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeSubtitle,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 12),
          Text(l10n.welcomeBody, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({required this.picked, required this.onToggle});

  final Set<String> picked;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingHabitsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.onboardingHabitsBody),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                for (final template in habitTemplates)
                  _TemplateTile(
                    id: template.id,
                    icon: template.icon,
                    colorKey: template.colorKey,
                    selected: picked.contains(template.id),
                    onTap: () => onToggle(template.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.id,
    required this.icon,
    required this.colorKey,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final String icon;
  final String colorKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = habitColor(colorKey);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected
            ? color.withValues(alpha: 0.14)
            : scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected
                ? color
                : scheme.outlineVariant.withValues(alpha: 0.5),
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(habitIcon(icon), color: color),
                const Spacer(),
                Text(
                  templateTitle(l10n, id),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderStep extends StatelessWidget {
  const _ReminderStep({
    required this.reminder,
    required this.onPick,
    required this.onClear,
  });

  final int? reminder;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            l10n.onboardingReminderTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.onboardingReminderBody),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: onPick,
            child: Text(
              reminder == null
                  ? l10n.reminder
                  : formatReminder(context, reminder),
            ),
          ),
          if (reminder != null)
            TextButton(onPressed: onClear, child: Text(l10n.clearReminder)),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
