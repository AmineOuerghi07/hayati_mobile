// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive so opening a habit does not rebuild the repository, which has
/// no state of its own beyond the shared database.

@ProviderFor(habitRepository)
final habitRepositoryProvider = HabitRepositoryProvider._();

/// keepAlive so opening a habit does not rebuild the repository, which has
/// no state of its own beyond the shared database.

final class HabitRepositoryProvider
    extends
        $FunctionalProvider<HabitRepository, HabitRepository, HabitRepository>
    with $Provider<HabitRepository> {
  /// keepAlive so opening a habit does not rebuild the repository, which has
  /// no state of its own beyond the shared database.
  HabitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitRepositoryHash();

  @$internal
  @override
  $ProviderElement<HabitRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HabitRepository create(Ref ref) {
    return habitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HabitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HabitRepository>(value),
    );
  }
}

String _$habitRepositoryHash() => r'0878495ea494280ba2dfa4a3f50ee94d6f1447e9';

@ProviderFor(completionRepository)
final completionRepositoryProvider = CompletionRepositoryProvider._();

final class CompletionRepositoryProvider
    extends
        $FunctionalProvider<
          CompletionRepository,
          CompletionRepository,
          CompletionRepository
        >
    with $Provider<CompletionRepository> {
  CompletionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CompletionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompletionRepository create(Ref ref) {
    return completionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompletionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompletionRepository>(value),
    );
  }
}

String _$completionRepositoryHash() =>
    r'67478c0181d81bf87a7b4931b5874790352d7f63';

@ProviderFor(activeHabits)
final activeHabitsProvider = ActiveHabitsProvider._();

final class ActiveHabitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Habit>>,
          List<Habit>,
          Stream<List<Habit>>
        >
    with $FutureModifier<List<Habit>>, $StreamProvider<List<Habit>> {
  ActiveHabitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeHabitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeHabitsHash();

  @$internal
  @override
  $StreamProviderElement<List<Habit>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Habit>> create(Ref ref) {
    return activeHabits(ref);
  }
}

String _$activeHabitsHash() => r'3f3e78aa2662130e3b0a78cdecbd9c18e285dfe2';

@ProviderFor(habitById)
final habitByIdProvider = HabitByIdFamily._();

final class HabitByIdProvider
    extends $FunctionalProvider<AsyncValue<Habit?>, Habit?, Stream<Habit?>>
    with $FutureModifier<Habit?>, $StreamProvider<Habit?> {
  HabitByIdProvider._({
    required HabitByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'habitByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitByIdHash();

  @override
  String toString() {
    return r'habitByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Habit?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Habit?> create(Ref ref) {
    final argument = this.argument as String;
    return habitById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitByIdHash() => r'6b7eddc6e18a5645467974ba9abc9124e1c2c22f';

final class HabitByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Habit?>, String> {
  HabitByIdFamily._()
    : super(
        retry: null,
        name: r'habitByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitByIdProvider call(String id) =>
      HabitByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'habitByIdProvider';
}

@ProviderFor(allCompletions)
final allCompletionsProvider = AllCompletionsProvider._();

final class AllCompletionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HabitCompletion>>,
          List<HabitCompletion>,
          Stream<List<HabitCompletion>>
        >
    with
        $FutureModifier<List<HabitCompletion>>,
        $StreamProvider<List<HabitCompletion>> {
  AllCompletionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allCompletionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allCompletionsHash();

  @$internal
  @override
  $StreamProviderElement<List<HabitCompletion>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HabitCompletion>> create(Ref ref) {
    return allCompletions(ref);
  }
}

String _$allCompletionsHash() => r'a9949a936664720ad80315c189b2cd23b3749db8';

@ProviderFor(completionsForHabit)
final completionsForHabitProvider = CompletionsForHabitFamily._();

final class CompletionsForHabitProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HabitCompletion>>,
          List<HabitCompletion>,
          Stream<List<HabitCompletion>>
        >
    with
        $FutureModifier<List<HabitCompletion>>,
        $StreamProvider<List<HabitCompletion>> {
  CompletionsForHabitProvider._({
    required CompletionsForHabitFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'completionsForHabitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completionsForHabitHash();

  @override
  String toString() {
    return r'completionsForHabitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<HabitCompletion>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HabitCompletion>> create(Ref ref) {
    final argument = this.argument as String;
    return completionsForHabit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletionsForHabitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completionsForHabitHash() =>
    r'34690bc07fb554cdf7b6d13a5543711fd344ae74';

final class CompletionsForHabitFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<HabitCompletion>>, String> {
  CompletionsForHabitFamily._()
    : super(
        retry: null,
        name: r'completionsForHabitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompletionsForHabitProvider call(String habitId) =>
      CompletionsForHabitProvider._(argument: habitId, from: this);

  @override
  String toString() => r'completionsForHabitProvider';
}
