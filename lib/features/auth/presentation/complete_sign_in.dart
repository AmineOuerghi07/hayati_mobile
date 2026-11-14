import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/domain/data_choice.dart';
import 'package:hayati/features/auth/presentation/account_data_providers.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/auth/presentation/data_choice_sheet.dart';
import 'package:hayati/features/sync/presentation/sync_providers.dart';
import 'package:material_ui/material_ui.dart';

/// After the session is written, decide what happens to the habits that
/// were already on this device. A guest with nothing to bring skips the sheet.
Future<void> completeSignIn(
  BuildContext context,
  WidgetRef ref,
  AuthUser user,
) async {
  final data = ref.read(accountDataRepositoryProvider);
  final here = await data.guestCounts();
  final account = await data.accountCounts(user.id);
  if (!context.mounted) return;
  final choice = !here.hasData
      ? DataChoice.keepAccount
      : await showDataChoiceSheet(
          context,
          here: here,
          account: account,
          accountHasData: account.hasData,
        );
  if (choice == null) {
    await ref.read(authRepositoryProvider).signOut();
    return;
  }
  await data.apply(user.id, choice);
  await ref.read(syncControllerProvider.notifier).syncNow();
  if (context.mounted) context.pop();
}
