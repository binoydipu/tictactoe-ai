import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tictactoeai/algorithm/minimax.dart';
import 'package:tictactoeai/constants/colors.dart';
import 'package:tictactoeai/constants/const_texts.dart';
import 'package:tictactoeai/utils/buttons/action_button.dart';
import 'package:tictactoeai/utils/buttons/control_button.dart';
import 'package:tictactoeai/utils/dialogs/reset_dialog.dart';
import 'package:tictactoeai/utils/buttons/back_button.dart';
import 'package:tictactoeai/utils/winning_condition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isXsTurn;
  late List<String> board;
  late final TextStyle textStyle;
  late int scoreO;
  late int scoreX;
  late bool isAiThinking;
  late String? isGameOver;
  late List<int> winningPositions;

  // Settings
  String gameMode = '2player';
  int boardSize = 9;

  @override
  void initState() {
    isXsTurn = true;
    board = List.filled(boardSize, '');
    textStyle = const TextStyle(color: Colors.white, fontSize: 30);
    scoreO = 0;
    scoreX = 0;
    winningPositions = [];
    isAiThinking = false;
    isGameOver = null;
    _resetGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          gameTitle,
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 14,
            color: textPrimary,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: glow,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        leading: const GameBackButton(),
        actions: [
          GameActionButton(
            icon: Icons.settings,
            onPressed: () => _showSettings(context),
            color: playerO,
            tooltip: 'Settings',
          ),
        ],
      ),
      backgroundColor: backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundDark,
              backgroundMedium,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Score Board
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundMedium.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerScore('Player X', scoreX, playerX),
                  Container(
                    height: 50,
                    width: 2,
                    color: border,
                  ),
                  _buildPlayerScore(
                    gameMode == '2player' ? 'Player O' : 'AI (O)',
                    scoreO,
                    playerO,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Game Board
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: shadow,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GridView.builder(
                    itemCount: boardSize,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: boardSize == 9 ? 3 : 5,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (winningPositions.isEmpty) {
                            if (gameMode == '2player') {
                              _tappedPlayer(index);
                            } else {
                              _tappedAi(index);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderLight,
                              width: 2,
                            ),
                            color: winningPositions.contains(index)
                                ? winningTile
                                : backgroundMedium,
                          ),
                          child: Center(
                            child: AnimatedScale(
                              scale: board[index].isNotEmpty ? 1.0 : 0.7,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                board[index],
                                style: TextStyle(
                                  fontFamily: 'PressStart2P',
                                  fontSize: boardSize == 9 ? 40 : 28,
                                  color:
                                      board[index] == 'X' ? playerX : playerO,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: shadow,
                                      offset: Offset(0, 0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            _aiThinkingWidget(),
            _gameResultMessage(isGameOver),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Show new game only when current game is over
                  if (isGameOver != null)
                    buildControlButton(
                      icon: Icons.refresh,
                      label: 'NEW GAME',
                      color: playerX, // Light blue
                      onPressed: () => _resetGame(),
                    ),
                  const SizedBox(height: 8),
                  buildControlButton(
                    icon: Icons.restart_alt,
                    label: 'RESET GAME',
                    color: playerO, // Amber
                    onPressed: () async {
                      bool confirmed =
                          await showResetConfirmationDialog(context: context);
                      scoreO = 0;
                      scoreX = 0;
                      if (confirmed) {
                        _resetGame();
                      }
                    },
                  ),
                ],
              ),
            ),
            // Footer
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                copyrightText,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 10,
                  color: textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String title, int score, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 10,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            '$score',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 16,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _tappedPlayer(int index) {
    setState(() {
      // Double Player
      if (isXsTurn && board[index] == '') {
        board[index] = 'X';
      } else if (board[index] == '') {
        board[index] = 'O';
      } else {
        return;
      }
      isXsTurn ^= true;
      _isGameOver();
    });
  }

  void _tappedAi(int index) async {
    if (board[index] != '') return;

    setState(() {
      board[index] = 'X';
      isAiThinking = true;
    });

    bool gameover = await _isGameOver();
    if (gameover) {
      setState(() {
        isAiThinking = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (isBoardFull(board)) {
      _isGameOver();
      setState(() {
        isAiThinking = false;
      });
      return;
    }

    int aiMove = await findBestMove(board: board, ai: 'O');

    setState(() {
      isAiThinking = false;
      board[aiMove] = 'O';
    });

    _isGameOver();
  }

  Widget _aiThinkingWidget() {
    return isAiThinking
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    FontAwesomeIcons.robot,
                    size: 30,
                    color: playerO,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "AI IS THINKING...",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 12,
                    color: playerO,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: glow,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _gameResultMessage(String? winner) {
    if (winner == null) return const SizedBox.shrink();
    String message;
    IconData icon;
    Color color;

    if (winner == 'X' || winner == 'O') {
      if (gameMode == 'ai') {
        winner = winner == 'O' ? 'AI' : 'Human';
      }
      message = 'Winner is: $winner';
      icon = FontAwesomeIcons.trophy;
      color = winner == 'X' ? playerX : playerO;
    } else {
      message = "It's a Tie!";
      icon = FontAwesomeIcons.handshake;
      color = playerO;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              size: 30,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            message,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 12,
              color: color,
              letterSpacing: 1,
              shadows: const [
                Shadow(
                  blurRadius: 8.0,
                  color: glow,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _isGameOver() async {
    String? result = checkWinner(board: board);
    if (result != null) {
      isGameOver = result;
      if (result == 'tie') {
        // await showDrawDialog(context: context);
      } else {
        result == 'X' ? scoreX++ : scoreO++;
        // await showWinDialog(winner: result, context: context);
        winningPositions = getWinningPositions(board: board);
      }
      return true;
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      isXsTurn = true;
      winningPositions = [];
      isGameOver = null;
      board = List.filled(boardSize, '');
    });
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blueGrey[800],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Game Settings',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        color: textPrimary,
                        letterSpacing: 2,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            blurRadius: 7.0,
                            color: glow,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Game Mode Selection
                    const Text(
                      'Game Mode',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    RadioListTile(
                      value: '2player',
                      groupValue: gameMode,
                      onChanged: (value) {
                        setModalState(() {
                          gameMode = value!;
                        });
                        setState(() {
                          gameMode = value!;
                          scoreO = 0;
                          scoreX = 0;
                        });
                        _resetGame();
                      },
                      title: const Text(
                        '2 Player',
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.white,
                    ),
                    RadioListTile(
                      value: 'ai',
                      groupValue: gameMode,
                      onChanged: (value) {
                        setModalState(() {
                          gameMode = value!;
                        });
                        setState(() {
                          gameMode = value!;
                          scoreO = 0;
                          scoreX = 0;
                        });
                        _resetGame();
                      },
                      title: const Text(
                        'Player vs AI',
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.white,
                    ),

                    const Divider(color: Colors.white70),

                    // Board Size Selection
                    const Text('Board Size',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    RadioListTile(
                      value: 9,
                      groupValue: boardSize,
                      onChanged: (value) {
                        setModalState(() {
                          boardSize = value!;
                        });
                        setState(() {
                          scoreO = 0;
                          scoreX = 0;
                        });
                        _resetGame();
                      },
                      title: const Text(
                        '3x3 Board',
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.white,
                    ),
                    RadioListTile(
                      value: 25,
                      groupValue: boardSize,
                      onChanged: (value) {
                        setModalState(() {
                          boardSize = value!;
                        });
                        setState(() {
                          scoreO = 0;
                          scoreX = 0;
                        });
                        _resetGame();
                      },
                      title: const Text(
                        '5x5 Board',
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
