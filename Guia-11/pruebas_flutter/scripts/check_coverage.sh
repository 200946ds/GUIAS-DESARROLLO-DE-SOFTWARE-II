#!/bin/bash
set -e

echo "▶ Ejecutando pruebas unitarias con cobertura..."
flutter test --coverage

if [ ! -f coverage/lcov.info ]; then
  echo "❌ No se generó coverage/lcov.info"
  exit 1
fi

# Filtrar archivos que no interesan (main, generados, etc.)
echo "▶ Filtrando archivos autogenerados..."
lcov --remove coverage/lcov.info \
  'lib/main.dart' \
  '*/.dart_tool/*' \
  '*/generated/*' \
  '*/*.g.dart' \
  '*/*.freezed.dart' \
  -o coverage/clean_lcov.info \
  --ignore-errors unused || cp coverage/lcov.info coverage/clean_lcov.info

# Calcular porcentaje
echo "▶ Calculando cobertura..."
COVERAGE=$(lcov --summary coverage/clean_lcov.info 2>&1 | grep "lines" | grep -o '[0-9.]*%' | head -1 | tr -d '%')

if [ -z "$COVERAGE" ]; then
  # Fallback simple si lcov summary falla
  TOTAL=$(grep -c "^DA:" coverage/clean_lcov.info || echo 0)
  HIT=$(grep "^DA:" coverage/clean_lcov.info | grep -c ",[1-9]" || echo 0)
  if [ "$TOTAL" -eq 0 ]; then
    COVERAGE=0
  else
    COVERAGE=$(echo "scale=2; $HIT * 100 / $TOTAL" | bc)
  fi
fi

echo "📊 Cobertura de líneas: ${COVERAGE}%"

THRESHOLD=85

# Comparación numérica
RESULT=$(echo "$COVERAGE < $THRESHOLD" | bc -l)

if [ "$RESULT" -eq 1 ]; then
  echo "❌ Cobertura insuficiente: ${COVERAGE}% < ${THRESHOLD}%"
  echo "El pipeline falla porque no se alcanza el umbral mínimo."
  exit 1
else
  echo "✅ Cobertura aceptable: ${COVERAGE}% >= ${THRESHOLD}%"
  exit 0
fi