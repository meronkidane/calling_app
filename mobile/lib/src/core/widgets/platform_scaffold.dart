import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key,
    required this.body,
    this.title,
    this.materialActions,
    this.cupertinoLeading,
    this.cupertinoTrailing,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? materialActions;
  final Widget? cupertinoLeading;
  final Widget? cupertinoTrailing;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.maybeOf(context)?.platform ?? defaultTargetPlatform;
    final isCupertino = platform == TargetPlatform.iOS;

    if (isCupertino) {
      Widget content = body;
      if (bottomNavigationBar != null) {
        content = Column(
          children: [
            Expanded(child: body),
            SafeArea(top: false, child: bottomNavigationBar!),
          ],
        );
      }

      content = Material(
        color: Colors.transparent,
        child: content,
      );

      return CupertinoPageScaffold(
        backgroundColor: backgroundColor ?? CupertinoColors.systemGroupedBackground,
        navigationBar: title != null
            ? CupertinoNavigationBar(
                middle: Text(title!),
                leading: cupertinoLeading,
                trailing: cupertinoTrailing,
                automaticallyImplyLeading: automaticallyImplyLeading,
              )
            : null,
        child: SafeArea(
          top: title == null,
          bottom: bottomNavigationBar == null,
          child: content,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              automaticallyImplyLeading: automaticallyImplyLeading,
              actions: materialActions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
