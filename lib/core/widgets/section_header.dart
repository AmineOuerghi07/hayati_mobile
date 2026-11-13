import 'package:material_ui/material_ui.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 8),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
