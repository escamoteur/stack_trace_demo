import 'package:flutter/material.dart';

class CommandSimple {
  final Future<void> Function() asyncFunc;
  final String name;

  final isExecuting = ValueNotifier(false);

  CommandSimple(this.asyncFunc, this.name);

  void execute() async {
    isExecuting.value = true;

    /// give the async notifications a chance to propagate
    await Future<void>.delayed(Duration.zero);

    try {
      await _execute();
    } catch (e, s) {
      print('Error executing command $name: $s');
    } finally {
      isExecuting.value = false;

      /// give the async notifications a chance to propagate
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<void> _execute() async {
    await asyncFunc();
  }
}
