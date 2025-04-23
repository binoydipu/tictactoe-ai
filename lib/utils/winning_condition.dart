String? checkWinner({
  required List<String> board,
}) {
  if (board.length == 25) {
    return _checkWinner5x5(board);
  } else if (board[0] == board[1] && board[0] == board[2] && board[0] != '') {
    return board[0];
  } else if (board[3] == board[4] && board[3] == board[5] && board[3] != '') {
    return board[3];
  } else if (board[6] == board[7] && board[6] == board[8] && board[6] != '') {
    return board[6];
  } else if (board[0] == board[3] && board[0] == board[6] && board[0] != '') {
    return board[0];
  } else if (board[1] == board[4] && board[1] == board[7] && board[1] != '') {
    return board[1];
  } else if (board[2] == board[5] && board[2] == board[8] && board[2] != '') {
    return board[2];
  } else if (board[0] == board[4] && board[0] == board[8] && board[0] != '') {
    return board[0];
  } else if (board[2] == board[4] && board[2] == board[6] && board[2] != '') {
    return board[2];
  } else if (isBoardFull(board)) {
    return 'tie';
  }
  return null;
}

String? _checkWinner5x5(List<String> board) {
  const int size = 5;

  String? checkPositions(List<int> pos) {
    if (board[pos[0]] == board[pos[1]] &&
        board[pos[1]] == board[pos[2]] &&
        board[pos[2]] == board[pos[3]] &&
        board[pos[0]] != '') {
      return board[pos[0]];
    }
    return null;
  }

  // Check rows
  for (int row = 0; row < size; row++) {
    for (int j = 0; j <= 1; j++) {
      int id = row * size + j;
      List<int> positions = [id, id + 1, id + 2, id + 3];
      String? winner = checkPositions(positions);
      if (winner != null) return winner;
    }
  }

  // Check columns
  for (int col = 0; col < size; col++) {
    for (int j = 0; j <= size; j += size) {
      int id = col + j;
      List<int> positions = [id, id + size, id + 2 * size, id + 3 * size];
      String? winner = checkPositions(positions);
      if (winner != null) return winner;
    }
  }

  // Right-down diagonals
  for (int row = 0; row <= 1; row++) {
    for (int col = 0; col <= 1; col++) {
      int id = row * size + col;
      List<int> positions = [id, id + size + 1, id + 2 * (size + 1), id + 3 * (size + 1)];
      String? winner = checkPositions(positions);
      if (winner != null) return winner;
    }
  }

  // Left-down diagonals
  for (int row = 0; row <= 1; row++) {
    for (int col = 3; col <= 4; col++) {
      int id = row * size + col;
      List<int> positions = [id, id + size - 1, id + 2 * (size - 1), id + 3 * (size - 1)];
      String? winner = checkPositions(positions);
      if (winner != null) return winner;
    }
  }

  if (isBoardFull(board)) {
    return 'tie';
  }

  // No winner
  return null;
}

bool isBoardFull(List<String> board) => !board.contains('');


List<int> getWinningPositions({
  required List<String> board,
}) {
  if (board.length == 25) {
    return _getWinningPositions5x5(board);
  } else if (board[0] == board[1] && board[0] == board[2] && board[0] != '') {
    return [0, 1, 2];
  } else if (board[3] == board[4] && board[3] == board[5] && board[3] != '') {
    return [3, 4, 5];
  } else if (board[6] == board[7] && board[6] == board[8] && board[6] != '') {
    return [6, 7, 8];
  } else if (board[0] == board[3] && board[0] == board[6] && board[0] != '') {
    return [0, 3, 6];
  } else if (board[1] == board[4] && board[1] == board[7] && board[1] != '') {
    return [1, 4, 7];
  } else if (board[2] == board[5] && board[2] == board[8] && board[2] != '') {
    return [2, 5, 8];
  } else if (board[0] == board[4] && board[0] == board[8] && board[0] != '') {
    return [0, 4, 8];
  } else if (board[2] == board[4] && board[2] == board[6] && board[2] != '') {
    return [2, 4, 6];
  }
  return [];
}

List<int> _getWinningPositions5x5(List<String> board) {
  const int size = 5;

  bool checkPositions(List<int> pos) {
    if (board[pos[0]] == board[pos[1]] &&
        board[pos[1]] == board[pos[2]] &&
        board[pos[2]] == board[pos[3]] &&
        board[pos[0]] != '') {
      return true;
    }
    return false;
  }

  // Check rows
  for (int row = 0; row < size; row++) {
    for (int j = 0; j <= 1; j++) {
      int id = row * size + j;
      List<int> positions = [id, id + 1, id + 2, id + 3];
      bool winner = checkPositions(positions);
      if (winner) return positions;
    }
  }

  // Check columns
  for (int col = 0; col < size; col++) {
    for (int j = 0; j <= size; j += size) {
      int id = col + j;
      List<int> positions = [id, id + size, id + 2 * size, id + 3 * size];
      bool winner = checkPositions(positions);
      if (winner) return positions;
    }
  }

  // Right-down diagonals
  for (int row = 0; row <= 1; row++) {
    for (int col = 0; col <= 1; col++) {
      int id = row * size + col;
      List<int> positions = [id, id + size + 1, id + 2 * (size + 1), id + 3 * (size + 1)];
      bool winner = checkPositions(positions);
      if (winner) return positions;
    }
  }

  // Left-down diagonals
  for (int row = 0; row <= 1; row++) {
    for (int col = 3; col <= 4; col++) {
      int id = row * size + col;
      List<int> positions = [id, id + size - 1, id + 2 * (size - 1), id + 3 * (size - 1)];
      bool winner = checkPositions(positions);
      if (winner) return positions;
    }
  }

  // No winner
  return [];
}