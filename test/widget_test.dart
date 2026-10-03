import 'package:blue_notes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('добавление, редактирование и удаление заметки', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NotesApp());

    expect(find.text('Заметок пока нет'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('newNoteField')),
      'Купить молоко',
    );
    await tester.tap(find.byKey(const Key('saveNoteButton')));
    await tester.pump();

    expect(find.text('Купить молоко'), findsOneWidget);
    expect(find.text('Заметки (1)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('editNote0')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('editNoteField')),
      'Купить хлеб',
    );
    await tester.tap(find.byKey(const Key('confirmEditButton')));
    await tester.pumpAndSettle();

    expect(find.text('Купить хлеб'), findsOneWidget);

    await tester.tap(find.byKey(const Key('deleteNote0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmDeleteButton')));
    await tester.pumpAndSettle();

    expect(find.text('Заметок пока нет'), findsOneWidget);
    expect(find.text('Заметки (0)'), findsOneWidget);
  });

  testWidgets('пустая заметка не сохраняется', (WidgetTester tester) async {
    await tester.pumpWidget(const NotesApp());

    await tester.tap(find.byKey(const Key('saveNoteButton')));
    await tester.pump();

    expect(find.text('Введите текст заметки'), findsOneWidget);
    expect(find.text('Заметки (0)'), findsOneWidget);
  });
}
