import 'dart:ui';

List<List<double>> matrixAdd(List<List<double>> A, List<List<double>> B) {
  List<List<double>> result = List.generate(3, (_) => List.filled(3, 0.0));
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      result[i][j] = A[i][j] + B[i][j];
    }
  }
  return result;
}

List<List<double>> matrixSubtract(List<List<double>> A, List<List<double>> B) {
  List<List<double>> result = List.generate(3, (_) => List.filled(3, 0.0));
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      result[i][j] = A[i][j] - B[i][j];
    }
  }
  return result;
}

List<List<double>> matrixMultiply(List<List<double>> A, List<List<double>> B) {
  List<List<double>> result = List.generate(3, (_) => List.filled(3, 0.0));
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 3; k++) {
        result[i][j] += A[i][k] * B[k][j];
      }
    }
  }
  return result;
}

List<List<double>> matrixScale(List<List<double>> A, double scaleFactor) {
  List<List<double>> result = List.generate(3, (_) => List.filled(3, 0.0));
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      result[i][j] = A[i][j] * scaleFactor;
    }
  }
  return result;
}

List<List<double>> getMatrixForSeverity(String type, double severity) {
  List<List<double>> matrix = [];

  if (type == 'PROTANOMALY') {
    matrix = [
      [0.567, 0.433, 0.0],
      [0.558, 0.442, 0.0],
      [0.0, 0.242, 0.758]
    ];
  } else if (type == 'DEUTERANOMALY') {
    matrix = [
      [0.625, 0.375, 0.0],
      [0.7, 0.3, 0.0],
      [0.0, 0.3, 0.7]
    ];
  } else if (type == 'TRITANOMALY') {
    matrix = [
      [0.95, 0.05, 0.0],
      [0.0, 0.433, 0.567],
      [0.0, 0.475, 0.525]
    ];
  } else if (type == 'MONOCHROMACY') {
    matrix = [
      [0.299, 0.587, 0.114],
      [0.299, 0.587, 0.114],
      [0.299, 0.587, 0.114]
    ];
  }

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      matrix[i][j] = matrix[i][j] * severity + (1 - severity) * ((i == j) ? 1 : 0);
    }
  }

  return matrix;
}

List<List<double>> getAdjustmentMatrix(String type, double adjustment) {
  List<List<double>> adjustmentMatrix = [
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
    [0.0, 0.0, 1.0],
  ];

  if (type == 'PROTANOMALY') {
    adjustmentMatrix = [
      [1.0 - adjustment, adjustment, 0.0],
      [adjustment, 1.0 - adjustment, 0.0],
      [0.0, 0.0, 1.0],
    ];
  } else if (type == 'DEUTERANOMALY') {
    adjustmentMatrix = [
      [1.0, 0.0, 0.0],
      [0.0, 1.0 - adjustment, adjustment],
      [0.0, adjustment, 1.0 - adjustment],
    ];
  } else if (type == 'TRITANOMALY') {
    adjustmentMatrix = [
      [1.0, 0.0, adjustment],
      [0.0, 1.0, 0.0],
      [adjustment, 0.0, 1.0 - adjustment],
    ];
  } else if (type == 'MONOCHROMACY') {
    adjustmentMatrix = [
      [1.0 - adjustment, adjustment, adjustment],
      [adjustment, 1.0 - adjustment, adjustment],
      [adjustment, adjustment, 1.0 - adjustment]
    ];
  }

  return adjustmentMatrix;
}

ColorFilter getColorFilterForTypeAndSeverity(String type, double severity, double adjustment) {
  List<List<double>> severityMatrix = getMatrixForSeverity(type, severity);
  List<List<double>> adjustmentMatrix = getAdjustmentMatrix(type, adjustment);

  List<List<double>> finalMatrix = matrixMultiply(severityMatrix, adjustmentMatrix);

  return ColorFilter.matrix([
    finalMatrix[0][0], finalMatrix[0][1], finalMatrix[0][2], 0, 0,
    finalMatrix[1][0], finalMatrix[1][1], finalMatrix[1][2], 0, 0,
    finalMatrix[2][0], finalMatrix[2][1], finalMatrix[2][2], 0, 0,
    0, 0, 0, 1, 0,
  ]);
}