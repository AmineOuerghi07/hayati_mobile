// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps OS reminders aligned with active habits.
///
/// keepAlive so leaving Today does not cancel the subscription that
/// reschedules after an edit, archive, or delete. Permission is requested
/// inside [ReminderCoordinator.sync], only when a reminder exists.

@ProviderFor(reminderCoordinator)
final reminderCoordinatorProvider = ReminderCoordinatorProvider._();

/// Keeps OS reminders aligned with active habits.
///
/// keepAlive so leaving Today does not cancel the subscription that
/// reschedules after an edit, archive, or delete. Permission is requested
/// inside [ReminderCoordinator.sync], only when a reminder exists.

final class ReminderCoordinatorProvider
    extends
        $FunctionalProvider<
          ReminderCoordinator,
          ReminderCoordinator,
          ReminderCoordinator
        >
    with $Provider<ReminderCoordinator> {
  /// Keeps OS reminders aligned with active habits.
  ///
  /// keepAlive so leaving Today does not cancel the subscription that
  /// reschedules after an edit, archive, or delete. Permission is requested
  /// inside [ReminderCoordinator.sync], only when a reminder exists.
  ReminderCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderCoordinatorHash();

  @$internal
  @override
  $ProviderElement<ReminderCoordinator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderCoordinator create(Ref ref) {
    return reminderCoordinator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderCoordinator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderCoordinator>(value),
    );
  }
}

String _$reminderCoordinatorHash() =>
    r'856cb5aa065fb395c9c15844d009a9035343616a';
