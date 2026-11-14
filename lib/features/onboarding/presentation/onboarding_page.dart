import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/platform/reminder_picker.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/growing_plant.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
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
  final _name = TextEditingController();
  final _picked = <String>{};
  var _index = 0;
  var _busy = false;
  int? _reminder;

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final growth = switch (_index) {
      0 => 0.3,
      1 => (0.4 + _picked.length * 0.1).clamp(0.4, 0.9).toDouble(),
      _ => 1.0,
    };
    final pages = PageView(
      controller: _page,
      onPageChanged: (index) => setState(() => _index = index),
      children: [
        _Welcome(scheme: scheme, name: _name),
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
    );
    final dots = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var dot = 0; dot < 3; dot++)
          AnimatedContainer(
            duration: tokens.motion(context, tokens.motionFast),
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            width: dot == _index ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: dot == _index ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
    final actions = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
      child: Row(
        children: [
          if (_index > 0)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => _page.previousPage(
                      duration: tokens.motion(context, tokens.motionMedium),
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
                        duration: tokens.motion(context, tokens.motionMedium),
                        curve: tokens.easeOut,
                      );
                      return;
                    }
                    _finish();
                  },
            child: Text(_index == 2 ? l10n.getStarted : l10n.continueAction),
          ),
        ],
      ),
    );
    return AuroraBackground(
      base: scheme.surface,
      colors: [
        scheme.primary.withValues(alpha: 0.22),
        scheme.tertiary.withValues(alpha: 0.18),
        scheme.secondaryContainer.withValues(alpha: 0.5),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: _busy ? null : _finish,
              child: Text(l10n.skip),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final short = constraints.maxHeight < 560;
              final landscape = constraints.maxWidth > constraints.maxHeight;
              final plant = GrowingPlant(
                progress: growth,
                size: short ? 96 : 120,
                semanticsLabel: l10n.plantGrowth((growth * 100).round()),
                flowerColor: scheme.tertiary,
              );
              final flow = ResponsiveWidth(
                maxWidth: 640,
                child: Column(
                  children: [
                    if (!short) plant,
                    Expanded(child: pages),
                    dots,
                    actions,
                  ],
                ),
              );
              if (short && landscape) {
                return Row(
                  children: [
                    Expanded(flex: 2, child: Center(child: plant)),
                    Expanded(flex: 5, child: flow),
                  ],
                );
              }
              return flow;
            },
          ),
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
    final chosenName = _name.text.trim();
    if (chosenName.isNotEmpty) {
      await ref
          .read(preferencesControllerProvider.notifier)
          .setDisplayName(chosenName);
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
  const _Welcome({required this.scheme, required this.name});

  final ColorScheme scheme;
  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FillScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          StaggeredItem(
            index: 0,
            child: Text(
              l10n.welcomeTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 8),
          StaggeredItem(
            index: 2,
            child: Text(
              l10n.welcomeSubtitle,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: scheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          StaggeredItem(
            index: 4,
            child: Text(
              l10n.welcomeBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20),
          StaggeredItem(
            index: 5,
            child: TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.yourName,
                hintText: l10n.namePrompt,
              ),
            ),
          ),
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
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingHabitsTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(l10n.onboardingHabitsBody),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
            ),
            itemCount: habitTemplates.length,
            itemBuilder: (context, index) {
              final template = habitTemplates[index];
              return StaggeredItem(
                index: index,
                child: _TemplateTile(
                  id: template.id,
                  icon: template.icon,
                  colorKey: template.colorKey,
                  selected: picked.contains(template.id),
                  onTap: () => onToggle(template.id),
                ),
              );
            },
          ),
        ),
      ],
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
    final tokens = HayatiTokens.of(context);
    final color = habitColor(colorKey);
    final duration = tokens.motion(context, tokens.motionMedium);
    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedScale(
        scale: selected ? 1.0 : 0.97,
        duration: duration,
        curve: tokens.checkOff,
        child: Material(
          color: selected
              ? Color.alphaBlend(
                  color.withValues(alpha: 0.14),
                  scheme.surfaceContainerLowest,
                )
              : scheme.surfaceContainerLowest.withValues(alpha: 0.85),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HabitBadge(icon: icon, colorKey: colorKey, size: 40),
                      const Spacer(),
                      AnimatedScale(
                        scale: selected ? 1 : 0,
                        duration: duration,
                        curve: Curves.elasticOut,
                        child: Icon(Icons.check_circle_rounded, color: color),
                      ),
                    ],
                  ),
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
    return _FillScroll(
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

/// Centers a column of [Spacer]-separated content when it fits, and lets it
/// scroll on short or landscape screens instead of overflowing.
class _FillScroll extends StatelessWidget {
  const _FillScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(28),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (constraints.maxHeight - 56).clamp(0, double.infinity),
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
