import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness_universe/l10n/app_localizations.dart';
import 'workout_store.dart';
import 'localized_duration.dart';

void main() => runApp(const FitnessUniverseApp());

class FitnessUniverseApp extends StatelessWidget {
  const FitnessUniverseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B5B)), useMaterial3: true),
    home: const FitnessHome(),
  );
}

class FitnessHome extends StatefulWidget {
  const FitnessHome({super.key});

  @override
  State<FitnessHome> createState() => _FitnessHomeState();
}

class _FitnessHomeState extends State<FitnessHome> {
  final store = WorkoutStore();
  final minutes = TextEditingController();
  String activity = 'walking';
  static const activities = ['walking', 'running', 'cycling', 'strength', 'yoga'];

  @override
  void initState() {
    super.initState();
    store.addListener(_refresh);
    store.load();
  }

  void _refresh() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    store.removeListener(_refresh);
    store.dispose();
    minutes.dispose();
    super.dispose();
  }

  String _activityLabel(AppLocalizations l, String key) => switch (key) {
    'walking' => l.walking,
    'running' => l.running,
    'cycling' => l.cycling,
    'strength' => l.strength,
    'yoga' => l.yoga,
    _ => key,
  };

  Future<void> _add(AppLocalizations l) async {
    final parsed = parseWorkoutMinutes(minutes.text);
    if (parsed == null || parsed < 1 || parsed > 1440) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.invalid)));
      return;
    }
    await store.add(activity, parsed);
    if (mounted) minutes.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l.heading, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l.privacy),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: activity,
          decoration: InputDecoration(labelText: l.activity, border: const OutlineInputBorder()),
          items: activities.map((key) => DropdownMenuItem(value: key, child: Text(_activityLabel(l, key)))).toList(),
          onChanged: (value) { if (value != null) setState(() => activity = value); },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: minutes,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l.minutes, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => _add(l), icon: const Icon(Icons.add), label: Text(l.save)),
        const SizedBox(height: 20),
        Text(l.summary(store.totalMinutes), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Text(l.history, style: Theme.of(context).textTheme.titleLarge),
        if (store.workouts.isEmpty) Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(l.empty),
        ),
        ...store.workouts.map((w) => Card(child: ListTile(
          title: Text('${_activityLabel(l, w.activity)} — ${w.minutes} min'),
          subtitle: Text(DateFormat.yMMMd(locale).add_Hm().format(w.timestamp.toLocal())),
          trailing: IconButton(
            tooltip: l.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => store.remove(w.id),
          ),
        ))),
      ]),
    );
  }
}
