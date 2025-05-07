import 'dart:math';
import 'package:tictactoeai/constants/game_constants.dart';

/// Evaluates the score for a certain depth (moves).
/// returns best score for smaller depth, i.e. min number of moves
int evaluate({
  required String? result,
  required int depth,
  required List<String> board,
}) {
  int score = 0;
  if (result != null) {
    score = scores[result]!;
  } else {
    score = evaluateBoard(board);
  }

  if (score == 0) {
    return 0;
  } else if (score < 0) {
    return score + (depth * loss);
  } else {
    return score - (depth * loss);
  }
}

/// Evaluates currect board score in favour of AI
int evaluateBoard(List<String> board) {
  final int size = board.length == 9 ? 3 : 5;
  final int winLength = size == 3 ? 3 : 4;

  int score = 0;

  // Score lines in rows, columns, and diagonals
  for (int row = 0; row < size; row++) {
    for (int col = 0; col < size; col++) {
      score +=
          _evaluateLine(board, size, row, col, 1, 0, winLength); // Horizontal
      score +=
          _evaluateLine(board, size, row, col, 0, 1, winLength); // Vertical
      score += _evaluateLine(
          board, size, row, col, 1, 1, winLength); // Diagonal down-right
      score += _evaluateLine(
          board, size, row, col, 1, -1, winLength); // Diagonal down-left
    }
  }

  return score;
}

int _evaluateLine(List<String> board, int size, int row, int col, int dRow,
    int dCol, int winLength) {
  int aiCount = 0;
  int playerCount = 0;

  for (int i = 0; i < winLength; i++) {
    int r = row + i * dRow;
    int c = col + i * dCol;

    if (r < 0 || r >= size || c < 0 || c >= size) return 0;

    String cell = board[r * size + c];
    if (cell == aiSymbol) {
      aiCount++;
    } else if (cell == playerSymbol) {
      playerCount++;
    }
  }

  if (aiCount > 0 && playerCount > 0) return 0; // Blocked line

  if (aiCount == winLength) return maxScore;
  if (playerCount == winLength) return -maxScore;

  // Heuristic scoring
  if (aiCount > 0) return pow(10, aiCount).toInt();
  if (playerCount > 0) return -pow(10, playerCount).toInt();

  // 1 in a row → 10
  // 2 in a row → 100
  // 3 in a row → 1000
  // 4 in a row = win

  return 0;
}
