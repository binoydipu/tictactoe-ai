import 'dart:math';
import 'package:tictactoeai/algorithm/evaluation.dart';
import 'package:tictactoeai/constants/game_constants.dart';
import 'package:tictactoeai/utils/winning_condition.dart';

Future<int> findBestMove({
  required List<String> board,
  required String ai,
}) {
  int bestScore = -infinity;
  int bestMove = -1;
  for (int i = 0; i < board.length; i++) {
    if (board[i] == '') {
      board[i] = aiSymbol;
      int score = minimax(board, false, 0, -infinity, infinity);
      board[i] = '';
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }
  return Future.value(bestMove);
}

int minimax(List<String> board, bool isMaxTurn, int depth, int alpha, int beta) {
  String? result = checkWinner(board: board);
  if (result != null || depth >= maxDepth) {
    return evaluate(
      result: result,
      depth: depth,
      board: board,
    );
  }

  if (isMaxTurn) {
    int bestScore = -infinity;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = aiSymbol;
        int score = minimax(board, false, depth + 1, alpha, beta);
        bestScore = max(bestScore, score);
        board[i] = '';

        alpha = max(alpha, bestScore);
        if (beta <= alpha) {
          break; // Beta cut-off
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = infinity;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = playerSymbol;
        int score = minimax(board, true, depth + 1, alpha, beta);
        bestScore = min(bestScore, score);
        board[i] = '';

        beta = min(beta, bestScore);
        if (beta <= alpha) {
          break; // Alpha cut-off
        }
      }
    }
    return bestScore;
  }
}
