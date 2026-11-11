import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pruebas_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo E2E - Gestión de Tareas', () {
    testWidgets(
      'Debe crear una tarea, mostrarla y luego eliminarla volviendo al estado vacío',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // 1. Lista vacía
        expect(find.byKey(const ValueKey('empty_state')), findsOneWidget);

        // 2. Abrir formulario
        await tester.tap(find.byKey(const ValueKey('fab_add_task')));
        await tester.pumpAndSettle();

        // 3. Escribir descripción
        await tester.enterText(
          find.byKey(const ValueKey('input_task_description')),
          'Entregar reporte de QA a producción',
        );

        // 4. Seleccionar prioridad Alta
        await tester.tap(find.byKey(const ValueKey('dropdown_priority')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ALTA').last);
        await tester.pumpAndSettle();

        // 5. Guardar
        await tester.tap(find.byKey(const ValueKey('btn_save_task')));
        await tester.pumpAndSettle();

        // 6. Verificar que aparece en la lista
        expect(
          find.text('Entregar reporte de QA a producción'),
          findsOneWidget,
        );
        expect(find.text('ALTA'), findsOneWidget);
        expect(find.byKey(const ValueKey('empty_state')), findsNothing);

        // 7. Eliminar con swipe
        await tester.drag(
          find.text('Entregar reporte de QA a producción'),
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        // 8. Volver a estado vacío
        expect(find.byKey(const ValueKey('empty_state')), findsOneWidget);
        expect(
          find.text('Entregar reporte de QA a producción'),
          findsNothing,
        );
      },
    );
  });
}