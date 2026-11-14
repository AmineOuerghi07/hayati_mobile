import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/auth/data/fake_auth_repository.dart';
import 'package:hayati/features/auth/data/local_account_data_repository.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/domain/data_choice.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:hayati/features/habits/data/drift_habit_repository.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

void main() {
  late AppDatabase database;
  late FakeAuthRepository auth;
  late DriftHabitRepository habits;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    auth = FakeAuthRepository(database);
    habits = DriftHabitRepository(database);
  });

  tearDown(() => database.close());

  test('a choice moves guest habits, and sign-in alone does not', () async {
    await habits.create(
      HabitDraft(
        name: 'Water',
        icon: 'water',
        colorKey: 'sea',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: CalendarDate.today().iso,
      ),
    );
    final data = LocalAccountDataRepository(database, MemorySyncRemote());
    final user = await auth.createAccount(
      email: 'amine@example.com',
      password: 'password1',
      displayName: 'Amine',
    );
    expect((await auth.watch().first).user?.id, user.id);
    expect((await data.accountCounts(user.id)).hasData, isFalse);
    expect((await habits.watchActive().first).single.name, 'Water');

    await data.apply(user.id, DataChoice.merge);
    expect((await habits.watchActive().first).single.name, 'Water');
    expect((await data.accountCounts(user.id)).habits, 1);

    await auth.signOut();
    expect((await auth.watch().first).isGuest, isTrue);
    expect(await habits.watchActive().first, isEmpty);

    await auth.signInWithEmail(
      email: 'amine@example.com',
      password: 'password1',
    );
    expect(await habits.watchActive().first, isEmpty);
    await data.apply(user.id, DataChoice.keepAccount);
    expect((await habits.watchActive().first).single.name, 'Water');
  });

  test('otp and password reset use the local demo code', () async {
    await auth.createAccount(
      email: 'amine@example.com',
      password: 'password1',
      displayName: 'Amine',
    );
    await auth.signOut();
    final challenge = await auth.requestOtp(destination: 'friend@example.com');
    expect(challenge.devCode, isNotNull);
    final created = await auth.verifyOtp(
      challengeId: challenge.id,
      code: challenge.devCode!,
    );
    expect(created.email, 'friend@example.com');
    expect(created.hasPassword, isFalse);

    final reset = await auth.requestPasswordReset(email: 'amine@example.com');
    await auth.resetPassword(
      challengeId: reset.id,
      code: reset.devCode!,
      newPassword: 'password2',
    );
    await auth.signOut();
    final signedIn = await auth.signInWithEmail(
      email: 'amine@example.com',
      password: 'password2',
    );
    expect(signedIn.displayName, 'Amine');
  });

  test('a wrong password does not delete the account', () async {
    await auth.createAccount(
      email: 'amine@example.com',
      password: 'password1',
      displayName: 'Amine',
    );
    expect(
      () => auth.deleteAccount(password: 'nope'),
      throwsA(AuthFailure.invalidCredentials),
    );
    expect((await auth.watch().first).isGuest, isFalse);
  });
}
