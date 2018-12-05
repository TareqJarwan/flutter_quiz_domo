import 'package:flutter/material.dart';

import '../pages/score_page.dart';
import '../ui/answer_button.dart';
import '../ui/correct_wrong_overlay.dart';
import '../ui/question_text.dart';
import '../utils/Question.dart';
import '../utils/Quiz.dart';

class QuizPage extends StatefulWidget {
	@override
	State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
	Question currentQuestion;
	String questionText;
	int questionNumber;
	bool isCorrect;
	bool overlayShouldBeVisible = false;
	
	Quiz quiz = new Quiz([
		new Question("Elon Musk is hummen", false),
		new Question("Pizza is healthy", false),
		new Question("Flutter is awesome", true)
	]);
	
	@override
	void initState() {
		super.initState();
		currentQuestion = quiz.nextQuestion;
		questionText = currentQuestion.question;
		questionNumber = quiz.questionNumber;
	}
	
	void handleAnswer(bool answer) {
		isCorrect = currentQuestion.answer == answer;
		quiz.answer(isCorrect);
		this.setState(() {
			overlayShouldBeVisible = true;
		});
	}
	
	@override
	Widget build(BuildContext context) {
		return new Stack(
			fit: StackFit.expand,
			children: <Widget>[
				new Column(
					children: <Widget>[
						new AnswerButton(true, () => handleAnswer(true)),
						new QuestionText(questionNumber, questionText),
						new AnswerButton(false, () => handleAnswer(false))
					],
				),
				overlayShouldBeVisible == true
					? new CorrectWrongOverlay(isCorrect, () {
					if (quiz.length == questionNumber) {
						Navigator.of(context).pushAndRemoveUntil(
							new MaterialPageRoute(
								builder: (BuildContext context) =>
								new ScorePage(quiz.score, quiz.length)),
								(Route route) => route == null);
						return;
					}
					currentQuestion = quiz.nextQuestion;
					this.setState(() {
						overlayShouldBeVisible = false;
						questionText = currentQuestion.question;
						questionNumber = quiz.questionNumber;
					});
				})
					: new Container()
			],
		);
	}
}
