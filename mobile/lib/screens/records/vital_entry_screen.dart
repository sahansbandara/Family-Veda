import 'package:family_veda/providers/active_member_provider.dart';
import 'package:family_veda/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VitalEntryScreen extends ConsumerStatefulWidget {
  const VitalEntryScreen({super.key});
  @override ConsumerState<VitalEntryScreen> createState() => _VitalEntryScreenState();
}

class _VitalEntryScreenState extends ConsumerState<VitalEntryScreen> {
  final _formKey = GlobalKey<FormState>(); final _type = TextEditingController(); final _value = TextEditingController(); final _unit = TextEditingController(); bool _saving = false;
  @override void dispose() { _type.dispose(); _value.dispose(); _unit.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Record vital')), body: SafeArea(child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Record the measured value only. Family Veda does not interpret it as a diagnosis.'),
    TextFormField(controller: _type, decoration: const InputDecoration(labelText: 'Vital type'), maxLength: 64, validator: _required),
    TextFormField(controller: _value, decoration: const InputDecoration(labelText: 'Value'), keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (value) => double.tryParse(value ?? '') == null ? 'Enter a numeric value.' : null),
    TextFormField(controller: _unit, decoration: const InputDecoration(labelText: 'Unit'), maxLength: 32, validator: _required),
    FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving…' : 'Save vital')),
  ]))));
  String? _required(String? value) => value == null || value.trim().isEmpty ? 'Required.' : null;
  Future<void> _save() async { if (!_formKey.currentState!.validate()) return; final memberId = ref.read(activeMemberProvider); if (memberId == null) return; setState(() => _saving = true); try { await ref.read(mobileApiProvider).addVital(memberId: memberId, vitalType: _type.text, value: double.parse(_value.text), unit: _unit.text, measuredAt: DateTime.now()); if (mounted) Navigator.of(context).pop(); } finally { if (mounted) setState(() => _saving = false); } }
}
