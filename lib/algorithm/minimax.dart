import 'dart:math';
import 'package:tictactoeai/utils/winning_condition.dart';

const infinity = 99999999;
const maxScore = 100000;
const maxDepth = 5;
const loss = 1;
const _ai = 'O';
const _player = 'X';

Map<String, int> scores = {
  'O': maxScore,
  'X': -maxScore,
  'tie': 0,
};

Future<int> findBestMove({
  required List<String> board,
  required String ai,
}) {
  int bestScore = -infinity;
  int bestMove = -1;
  for (int i = 0; i < board.length; i++) {
    if (board[i] == '') {
      board[i] = _ai;
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

/// Evaluates the score for a certain depth (moves).
/// returns best score for smaller depth, i.e. min number of moves
int evaluate(int score, int depth) {
  if (score == 0) {
    return 0;
  } else if (score < 0) {
    return score + (depth * loss);
  } else {
    return score - (depth * loss);
  }
}

int minimax(
    List<String> board, bool isMaxTurn, int depth, int alpha, int beta) {
  String? result = checkWinner(board: board);
  if (result != null || depth >= maxDepth) {
    if (result == null) return 0;
    return evaluate(scores[result]!, depth);
  }

  if (isMaxTurn) {
    int bestScore = -infinity;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = _ai;
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
        board[i] = _player;
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
