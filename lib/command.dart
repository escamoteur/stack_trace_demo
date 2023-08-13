import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

class CommandSimple {
  final Future<void> Function() asyncFunc;
  final String? name;

  final isExecuting = ValueNotifier(false);

  Trace? _traceBeforeExecute;

  CommandSimple(this.asyncFunc, this.name);

  void execute() async {
    _traceBeforeExecute = Trace.current();
    isExecuting.value = true;

    /// give the async notifications a chance to propagate
    await Future<void>.delayed(Duration.zero);

    try {
      await _execute();
    } catch (e, s) {
      final trace = _improveStacktrace(s);
      print('Error executing command $name: $trace');
    } finally {
      isExecuting.value = false;

      /// give the async notifications a chance to propagate
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<void> _execute() async {
    await asyncFunc();
  }

  Chain _improveStacktrace(
    StackTrace stacktrace,
  ) {
    var trace = Trace.from(stacktrace);

    final strippedFrames = trace.frames
        .where((frame) => switch (frame) {
              Frame(package: 'stack_trace') => false,
              Frame(:final member) when member!.contains('Zone') => false,
              Frame(:final member) when member!.contains('_rootRun') => false,
              Frame(:final member) when member!.contains('_execute') => false,
              _ => true,
            })
        .toList();
    final commandFrame = strippedFrames.removeLast();
    strippedFrames.add(Frame(
      commandFrame.uri,
      commandFrame.line,
      commandFrame.column,
      name != null ? '${commandFrame.member} ($name)' : commandFrame.member,
    ));
    trace = Trace(strippedFrames);

    final framesBefore = _traceBeforeExecute?.frames
            .where((frame) => frame.package != 'flutter_command') ??
        [];

    final chain = Chain([
      trace,
      Trace(framesBefore),
    ]);

    return chain.terse;
  }
}
