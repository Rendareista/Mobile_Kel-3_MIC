import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NameInputScreen(),
    );
  }
}

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({Key? key}) : super(key: key);

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(userName: name),
                    ),
                  );
                }
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String userName;

  const QuizPage({Key? key, required this.userName}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizModel quizModel = QuizModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName} - Space Quiz'),
        backgroundColor: const Color.fromARGB(255, 131, 158, 245),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hujan.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Question ${quizModel.currentQuestionIndex + 1}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              Text(
                quizModel.currentQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Column(
                children: quizModel.currentOptions.map((option) {
                  return ListTile(
                    title: Text(option, style: const TextStyle(color: Colors.white)),
                    leading: Radio(
                      value: option.substring(0, 1),
                      groupValue: quizModel.selectedAnswers[quizModel.currentQuestionIndex],
                      onChanged: (String? value) {
                        setState(() {
                          quizModel.selectedAnswers[quizModel.currentQuestionIndex] = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              quizModel.isAnswered()
                  ? quizModel.selectedAnswers[quizModel.currentQuestionIndex] == quizModel.correctAnswers[quizModel.currentQuestionIndex]
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 30.0,
                          ),
                        )
                      : Container()
                  : const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Kamu belum mengisi jawaban ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromARGB(255, 216, 238, 14)),
                      ),
                    ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        quizModel.previousQuestion();
                      });
                    },
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        quizModel.nextQuestion();
                        if (quizModel.currentQuestionIndex == quizModel.questions.length - 1) {
                          quizModel.calculateScore();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Quiz Finished'),
                                content: Text('Your score: ${quizModel.score}/${quizModel.questions.length}'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizModel {
  List<String> questions = [
    'Mengapa dia tidak mencintai saya?',
    'Bagaimana kipas angin bergerak?',
    'Sebutkan 2 musim di Indonesia?',
    'Sebutkan satu alasan kamu menjadi backburner?',
    'Berapa kali muslim melaksanakan sholat?',
    'Hewan yang hidup di dua dunia disebut?',
    '100 x 100 =',
    'Bunga apa yang terkenal di Belanda?',
    'Matahari tenggelam di sebelah?',
    'Hewan yang tidak memiliki tulang belakang?'
  ];
  List<List<String>> options = [
    ['A. Karena dia tidak menginginkan kamu', 'B. Terlalu pd', 'C. Karena kamu jelek', 'D. Tidak ada yang mau menerima kamu'],
    ['A. Karena angin yang meniupnya', 'B.Karena listrik menggerakkannya', 'C. Karena didorong oleh tangan', 'D. Karena beratnya yang menarik'],
    ['A. Musim Semi dan Musim Gugur', 'B. Musim Dingin dan Musim Panas', 'C. Musim Hujan dan Musim Kering', 'D. Musim Gugur dan Musim Bunga'],
    ['A. Kamu kurang menarik', 'B. Kamu lebih fokus dengan pekerjaanmu', 'C. Kamu kurang memperhatikannya', 'D. Karena kamu bukan prioritasnya'],
    ['A. 1 kali', 'B. 3 kali', 'C. 5 kali', 'D. 7 kali'],
    ['A. Mamalia', 'B. Pisces', 'C. Amfibi', 'D. Unggas'],
    ['A. 100', 'B. 1000', 'C.10.000', 'D.100.000'],
    ['A. Melati', 'B. Mawar', 'C. Anggrek', 'D. Tulip'],
    ['A. Barat', 'B. Timur', 'C. Utara', 'D. Selatan'],
    ['A. Salamander', 'B. Pari', 'C. Landak laut', 'D. Kura-kura']
  ];
  List<String> correctAnswers = [
    'A', 'B', 'C', 'D', 'C', 'C', 'C', 'D', 'A', 'C'
  ];
  List<String?> selectedAnswers = [
    null, null, null, null, null, null, null, null, null, null
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  String get currentQuestion => questions[currentQuestionIndex];
  List<String> get currentOptions => options[currentQuestionIndex];

  bool isAnswered() {
    return selectedAnswers[currentQuestionIndex] != null;
  }

  void calculateScore() {
    score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        score++;
      }
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      if (isAnswered()) {
        currentQuestionIndex++;
      }
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
    }
  }
}
