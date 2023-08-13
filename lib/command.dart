import 'package:flutter/material.dart';

class Command {
  final Future<void> Function() asyncFunc;
  final String name;

  final isExecuting = ValueNotifier(false);

  Command(this.asyncFunc, this.name);

  void execute() async {
    isExecuting.value = true;

    /// give the async notifications a chance to propagate
    await Future<void>.delayed(Duration.zero);

    try {
      await asyncFunc();
    } catch (e, s) {
      print('Error executing command $name: $e, $s');
    } finally {
      isExecuting.value = false;
    }
  }
}
