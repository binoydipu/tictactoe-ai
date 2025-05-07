const infinity = 99999999;
const maxScore = 100000;
const maxDepth = 4;
const loss = 1;
const aiSymbol = 'O';
const playerSymbol = 'X';

const Map<String, int> scores = {
  'O': maxScore,
  'X': -maxScore,
  'tie': 0,
};