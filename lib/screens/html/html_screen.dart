import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Html(
          data: """
                 <div style="color:red; text-align: center; font-weight: bold">Zaplanuj konkretną godzinę i umów się ze swoią ŻONĄ NA RANDKĘ.</div><br />

Posłuchaj o tym jak się przygotować do randki.<br /><br />
<audio style="width:100%;margin-bottom:20px" controls src="https://assets.app40dni.x25.pl/randka_audycja_1_cz1.mp3"></audio>
</br>
<b>Wasze wspólne spotkanie "poprowadzi" specjalna <span style="color:red">interaktywna audycja.</span> Mamy nadzieję, że pomoże Wam ona przeżyć pięknie i owocnie ten czas.</b>
                  """,
        ),
      ),
    );
  }
}
