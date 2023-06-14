import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


class Scoreboard extends StatefulWidget {
  final List<Map<String, String>> userScores;
  final String currentUserID;

  Scoreboard({
    required this.userScores,
    required this.currentUserID,
  });

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard>
    with SingleTickerProviderStateMixin {
  late List<ScoreEntry> sortedEntries;
  late int currentUserIndex;
  late AnimationController _animationController;
  double _currentPosition = 0.0;
  int maxScoreboardSize = 10;

  @override
  void initState() {
    super.initState();
    // sortedEntries = widget.userScores.entries
    //     .map((entry) => ScoreEntry(name: entry.key, score: entry.value))
    //     .toList()
    sortedEntries = [];
    for (Map<String, String> entry in widget.userScores) {
      sortedEntries.add(ScoreEntry(
          id: entry['id']!,
          score: int.parse(entry['score']!),
          username: entry['username']!,
          correctAnswers: entry['correct_answers']!));
    }
    sortedEntries = sortedEntries..sort((a, b) => b.score.compareTo(a.score));

    currentUserIndex =
        sortedEntries.indexWhere((entry) => entry.id == widget.currentUserID);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animationController.addListener(() {
      setState(() {
        _currentPosition = _animationController.value * currentUserIndex;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView.builder(
        itemCount: sortedEntries.length + 1,
        itemBuilder: (context, index) {
          if (index == sortedEntries.length) {
            // Render a separate row for the current user at the bottom
            // print(sortedEntries.last.score);
            return (sortedEntries.last.id == widget.currentUserID &&
                    sortedEntries.length == maxScoreboardSize + 1)
                ? _buildSeparateRow()
                : Container(); // Empty container if current user's score is not lower than the last score
          }

          ScoreEntry entry = sortedEntries[index];

          if (index == _currentPosition.floor()) {
            // Render a magnifying glass effect for the current user
            return _buildAnimatedMagnifyingGlassRow(entry, index + 1);
          }

          // Render a regular score entry
          return ListTile(
            leading: Text(
                index + 1 > maxScoreboardSize ? '' : (index + 1).toString()),
            // Display the place (index + 1)
            title: Text(entry.username),
            subtitle: Text(AppLocalizations.of(context).translate('Correct Answers')+': ${entry.correctAnswers}'),
            trailing: Text(entry.score.toString()),
          );
        },
      ),
    );
  }

  Widget _buildSeparateRow() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(15.0),
      child: Text(
        'Your score is lower than the ${maxScoreboardSize}th place.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnimatedMagnifyingGlassRow(ScoreEntry entry, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double scale = 1.2 -
            (_animationController.value * 0.2); // Scale down as it scrolls
        double opacity =
            1.0 - (_animationController.value * 0.5); // Fade out as it scrolls

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow[100], // Yellow background color
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    blurRadius: 10.0, // Shadow blur radius
                    spreadRadius: 5.0, // Shadow spread radius
                  ),
                ],
              ),
              child: ListTile(
                leading: Text(
                  index >= maxScoreboardSize ? '' : (index).toString(),
                  style: TextStyle(
                    fontSize: 18.0, // Increase the font size for larger text
                    fontWeight: FontWeight.bold,
                  ),
                ), // Magnifying glass icon
                title: Text(
                  entry.username,
                  style: TextStyle(
                    fontSize: 18.0, // Increase the font size for larger text
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context).translate('Correct Answers')+': ${entry.correctAnswers}',
                  style: TextStyle(
                    fontSize: 18.0, // Increase the font size for larger text
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  entry.score.toString(),
                  style: TextStyle(
                    fontSize: 18.0, // Increase the font size for larger text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScoreEntry {
  final String id;
  final int score;
  final String correctAnswers;
  final String username;

  ScoreEntry(
      {required this.id,
      required this.correctAnswers,
      required this.score,
      required this.username});
}
