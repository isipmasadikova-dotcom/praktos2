import 'package:blue_notes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('заметку можно добавить, изменить и удалить', (tester) async {
    await tester.pumpWidget(const NotesApp());

    await tester.enterText(
      find.byKey(const Key('noteField')),
      'Первая заметка',
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pump();
    expect(find.text('Первая заметка'), findsOneWidget);

    await tester.tap(find.byKey(const Key('edit0')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('editField')),
      'Измененная заметка',
    );
    await tester.tap(find.byKey(const Key('confirmEdit')));
    await tester.pumpAndSettle();
    expect(find.text('Измененная заметка'), findsOneWidget);

    await tester.tap(find.byKey(const Key('delete0')));
    await tester.pump();
    expect(find.text('Измененная заметка'), findsNothing);
  });
}
