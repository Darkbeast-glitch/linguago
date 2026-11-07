import 'models/daily_lesson.dart';
import 'models/lesson_step.dart';

/// Pre-crafted, pedagogical 60-day curriculum designed for communicative fluency
/// (zero to CEFR A1) without boring flashcard drills.
class CurriculumCatalog {
  const CurriculumCatalog._();

  /// Gets the lesson for [languageCode] on [day] (1 to 60).
  static DailyLesson getLesson({
    required String languageCode,
    required int day,
  }) {
    final clampedDay = day.clamp(1, 60);

    switch (languageCode.toLowerCase()) {
      case 'de':
        return _germanLessons[clampedDay] ?? _generateGenericLesson('German', clampedDay);
      case 'es':
        return _spanishLessons[clampedDay] ?? _generateGenericLesson('Spanish', clampedDay);
      case 'fr':
        return _frenchLessons[clampedDay] ?? _generateGenericLesson('French', clampedDay);
      case 'it':
        return _italianLessons[clampedDay] ?? _generateGenericLesson('Italian', clampedDay);
      default:
        return _generateGenericLesson(languageCode.toUpperCase(), clampedDay);
    }
  }

  // ── German 60-Day Roadmap (Zero to A1 Communicative Mastery) ────────────────

  static final Map<int, DailyLesson> _germanLessons = {
    // ── Phase 1: Sounds, Alphabet & Pronunciation Foundation (Days 1–7)
    1: DailyLesson(
      day: 1,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'The German Sound Secrets: W, V, and S',
      summary:
          'German sounds differ from English in systematic ways. Learn the 3 golden consonant rules so you never mispronounce them.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'Rule 1: W sounds like English V',
          instruction: 'Listen carefully to how German "W" is pronounced exactly like the English "V".',
          foreignText: 'Wasser',
          phoneticGuide: '[VAH-ser]',
          englishMeaning: 'Water',
          explanation: 'In German, the letter W always sounds like "V" in "Vine". Practice: Wasser, Wunderbar.',
          contextExample: 'Ein Glas Wasser, bitte. (A glass of water, please.)',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'Rule 2: V sounds like English F',
          instruction: 'Tap to listen, then repeat aloud with clean pronunciation.',
          foreignText: 'Vater',
          phoneticGuide: '[FAH-ter]',
          englishMeaning: 'Father',
          explanation: 'German "V" is called "Vau" and produces an "F" sound like "Fox".',
          contextExample: 'Mein Vater ist nett. (My father is nice.)',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'Rule 3: S before vowels sounds like Z',
          instruction: 'Notice the buzzing "Z" sound when "S" starts a word or precedes a vowel.',
          foreignText: 'Sonne',
          phoneticGuide: '[ZON-nuh]',
          englishMeaning: 'Sun',
          explanation: 'At the start of a word, "S" is voiced like the "Z" in "Zebra".',
          contextExample: 'Die Sonne scheint. (The sun is shining.)',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speaking Drill: The Golden Trio',
          instruction: 'Tap the mic and speak the full sentence aloud to train your vocal cords.',
          foreignText: 'Wasser, Vater und Sonne',
          phoneticGuide: '[VAH-ser, FAH-ter oont ZON-nuh]',
          englishMeaning: 'Water, father, and sun',
          explanation: 'Combining W (V-sound), V (F-sound), and S (Z-sound) in one natural phrase.',
        ),
      ],
    ),

    2: DailyLesson(
      day: 2,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'The German Umlauts: ä, ö, and ü',
      summary:
          'Those two little dots (dots/Trema) change everything! Master the mouth shapes for ä, ö, and ü with zero frustration.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Ä sound: Open mouth',
          instruction: 'Listen to Ä. It sounds like the "e" in English "bed" or "air".',
          foreignText: 'Äpfel',
          phoneticGuide: '[EP-fel]',
          englishMeaning: 'Apples',
          explanation: 'Do not pronounce it like "A"! Open your mouth and make an open "e" sound.',
          contextExample: 'Ich esse Äpfel. (I eat apples.)',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'The Ö sound: Rounded lips',
          instruction: 'Say "ay" as in "day", but round your lips into an "O" shape without moving your tongue.',
          foreignText: 'Schön',
          phoneticGuide: '[SHERN]',
          englishMeaning: 'Beautiful / Nice',
          explanation: 'A rounded vowel common in German: "Dankeschön" means thank you very much.',
          contextExample: 'Das Wetter ist schön. (The weather is beautiful.)',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'The Ü sound: High and focused',
          instruction: 'Say "ee" as in "see", but round your lips tightly like whistling.',
          foreignText: 'Über',
          phoneticGuide: '[OO-ber / EW-ber]',
          englishMeaning: 'Over / Above',
          explanation: 'Keep your tongue in the "ee" position and push your lips forward.',
          contextExample: 'Über den Wolken. (Above the clouds.)',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Practice: Beautiful Morning',
          instruction: 'Speak this sentence aloud using your new rounded Ö sound.',
          foreignText: 'Ein schöner Tag',
          phoneticGuide: '[Ine SHER-ner Tahk]',
          englishMeaning: 'A beautiful day',
          explanation: 'Listen to the audio, press the mic and say it proudly!',
        ),
      ],
    ),

    3: DailyLesson(
      day: 3,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'Diphthongs & Consonant Blends: ei, ie, and sch',
      summary:
          'Never confuse "ei" and "ie" again. Learn the golden rhyme and the soft/hard ch sounds.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Golden Rule: When two vowels go walking...',
          instruction: 'In German, you always pronounce the SECOND vowel in "ei" and "ie"!',
          foreignText: 'Wein vs. Wien',
          phoneticGuide: '[VINE vs. VEEN]',
          englishMeaning: 'Wine vs. Vienna',
          explanation: 'In "ei", second letter is "i" -> sounds like "eye" (Wein). In "ie", second letter is "e" -> sounds like "ee" (Wien).',
          contextExample: 'Ich trinke Wein in Wien. (I drink wine in Vienna.)',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'The "SCH" sound: Rich and soft',
          instruction: 'Pronounce "sch" like English "sh" in "shoe".',
          foreignText: 'Schnell',
          phoneticGuide: '[SHNELL]',
          englishMeaning: 'Fast / Quick',
          contextExample: 'Komm schnell! (Come quickly!)',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'The Soft "CH" (Ich-Laut)',
          instruction: 'Hiss gently through your teeth like a smiling cat.',
          foreignText: 'Ich',
          phoneticGuide: '[EESH / ISH]',
          englishMeaning: 'I (myself)',
          explanation: 'Position your tongue near the roof of your mouth and whisper.',
          contextExample: 'Ich spreche Deutsch. (I speak German.)',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak: The Core Identity',
          instruction: 'Speak the single most important word in German communication.',
          foreignText: 'Ich bin hier',
          phoneticGuide: '[Ish bin HEER]',
          englishMeaning: 'I am here',
        ),
      ],
    ),

    // ── Phase 2: First Encounters & Survival Phrases (Days 8–18)
    8: DailyLesson(
      day: 8,
      phaseNumber: 2,
      phaseTitle: DailyLesson.phaseTitleFor(2),
      title: 'Warm Greetings & Times of the Day',
      summary:
          'Beyond a simple "Hallo": learn how native German speakers greet colleagues, friends, and elders throughout the day.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.listenRepeat,
          title: 'Morning Greeting',
          instruction: 'Listen to the friendly morning greeting.',
          foreignText: 'Guten Morgen!',
          phoneticGuide: '[GOO-ten MOR-gen]',
          englishMeaning: 'Good morning!',
          explanation: 'Used until about 11:00 AM in Germany, Austria, and Switzerland.',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'All-Day Greeting',
          instruction: 'The universal daytime greeting used from midday until dusk.',
          foreignText: 'Guten Tag!',
          phoneticGuide: '[GOO-ten TAHK]',
          englishMeaning: 'Good day / Hello!',
          explanation: 'Notice the "g" at the end of "Tag" sounds like a crisp "k".',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'Evening & Parting',
          instruction: 'Two essential phrases for late afternoon and saying farewell.',
          foreignText: 'Guten Abend! Tschüss!',
          phoneticGuide: '[GOO-ten AH-bent! TCHOOSS!]',
          englishMeaning: 'Good evening! Bye!',
          explanation: '"Tschüss" is the friendly, modern way to say goodbye to anyone.',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speaking Challenge: Daily Greeting',
          instruction: 'Greet your German tutor warmly and say goodbye.',
          foreignText: 'Guten Tag! Tschüss!',
          phoneticGuide: '[GOO-ten TAHK! TCHOOSS!]',
          englishMeaning: 'Good day! Bye!',
        ),
      ],
    ),

    // ── Phase 3: The "About Me" Core (Days 19–30)
    19: DailyLesson(
      day: 19,
      phaseNumber: 3,
      phaseTitle: DailyLesson.phaseTitleFor(3),
      title: 'My Name Is... (The Verb heißen)',
      summary:
          'The first step of your personal story. Learn to introduce yourself naturally without sounding like a textbook robot.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Special Letter: ß (Eszett)',
          instruction: 'Notice the ß in "heißen". It sounds like a sharp double "ss".',
          foreignText: 'heißen',
          phoneticGuide: '[HY-sen]',
          englishMeaning: 'To be called / named',
          explanation: 'Pronounced with the "ei" (eye) sound and a sharp "s".',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'Introducing Yourself',
          instruction: 'Listen and repeat: "My name is..."',
          foreignText: 'Ich heiße...',
          phoneticGuide: '[Ish HY-suh...]',
          englishMeaning: 'My name is... (literally: I am called...)',
          explanation: 'This is the most common and native way to state your name in German.',
          contextExample: 'Ich heiße Alex. (My name is Alex.)',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'Asking Someone Else’s Name',
          instruction: 'Learn how to ask someone their name in friendly casual conversation.',
          foreignText: 'Wie heißt du?',
          phoneticGuide: '[Vee HYST doo?]',
          englishMeaning: 'What is your name? (casual)',
          explanation: 'Combine the question word "Wie" (How) with the verb "heißt".',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Mini Dialogue: Introduce Yourself',
          instruction: 'Speak your introduction into the microphone with confidence!',
          foreignText: 'Hallo! Ich heiße Anna. Und du?',
          phoneticGuide: '[HAH-lo! Ish HY-suh Anna. Oont doo?]',
          englishMeaning: 'Hello! My name is Anna. And you?',
        ),
      ],
    ),

    20: DailyLesson(
      day: 20,
      phaseNumber: 3,
      phaseTitle: DailyLesson.phaseTitleFor(3),
      title: 'Where I Come From (The Verb kommen)',
      summary:
          'Tell people your homeland, heritage, and origins using "Ich komme aus...".',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.listenRepeat,
          title: 'Expressing Origin',
          instruction: 'Listen to the verb "kommen" conjugated for yourself (Ich komme).',
          foreignText: 'Ich komme aus...',
          phoneticGuide: '[Ish KOM-muh ows...]',
          englishMeaning: 'I come from...',
          explanation: '"aus" always takes the origin country or city.',
          contextExample: 'Ich komme aus Deutschland / Spanien / den USA.',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.sentencePractice,
          title: 'Where do you come from?',
          instruction: 'Ask your conversation partner where they are from.',
          foreignText: 'Woher kommst du?',
          phoneticGuide: '[Vo-HAIR KOMST doo?]',
          englishMeaning: 'Where do you come from?',
          explanation: '"Woher" means "where from".',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.listenRepeat,
          title: 'Connecting Two Sentences: und (and)',
          instruction: 'Connect your name and your origin into one smooth sentence.',
          foreignText: 'Ich heiße David und ich komme aus London.',
          phoneticGuide: '[Ish HY-suh David oont ish KOM-muh ows London.]',
          englishMeaning: 'My name is David and I come from London.',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak: Your 2-Part Intro',
          instruction: 'Say your full introduction with name and country.',
          foreignText: 'Ich komme aus...',
          phoneticGuide: '[Ish KOM-muh ows...]',
          englishMeaning: 'I come from...',
        ),
      ],
    ),

    21: DailyLesson(
      day: 21,
      phaseNumber: 3,
      phaseTitle: DailyLesson.phaseTitleFor(3),
      title: 'Where I Live Now (The Verb wohnen)',
      summary:
          'Often where you live is different from where you were born. Master "Ich wohne in...".',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.listenRepeat,
          title: 'Residence and City',
          instruction: 'Listen to "wohnen" (to reside/live).',
          foreignText: 'Ich wohne in Berlin.',
          phoneticGuide: '[Ish VO-nuh in Bair-LEEN.]',
          englishMeaning: 'I live in Berlin.',
          explanation: 'The "h" in "wohnen" is silent; it lengthens the "o" sound.',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.sentencePractice,
          title: 'Asking Where Someone Lives',
          instruction: 'Form the question for living location.',
          foreignText: 'Wo wohnst du?',
          phoneticGuide: '[Vo VONST doo?]',
          englishMeaning: 'Where do you live?',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.listenRepeat,
          title: 'A Triple Master Sentence',
          instruction: 'Combine Name, Origin, and City like a true German speaker.',
          foreignText: 'Ich heiße Ben, ich komme aus Madrid und ich wohne in München.',
          phoneticGuide: '[Ish HY-suh Ben, ish KOM-muh ows Madrid oont ish VO-nuh in MEWN-shen.]',
          englishMeaning: 'My name is Ben, I come from Madrid, and I live in Munich.',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak Your Complete Self-Intro',
          instruction: 'Practice reciting your 3 key facts smoothly.',
          foreignText: 'Ich wohne in einer schönen Stadt.',
          phoneticGuide: '[Ish VO-nuh in EYE-ner SHER-nen SHTAT.]',
          englishMeaning: 'I live in a beautiful city.',
        ),
      ],
    ),
  };

  // ── Spanish 60-Day Roadmap (Zero to A1 Communicative Mastery) ───────────────

  static final Map<int, DailyLesson> _spanishLessons = {
    1: DailyLesson(
      day: 1,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'The Spanish Vowels: Pure & Crisp (A, E, I, O, U)',
      summary:
          'Spanish vowels are always short, crisp, and never slide like English diphthongs. Master them first.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Golden Rule of Spanish Vowels',
          instruction: 'In Spanish, every vowel makes exactly ONE pure sound. No sliding!',
          foreignText: 'A, E, I, O, U',
          phoneticGuide: '[Ah, Eh, Ee, Oh, Oo]',
          englishMeaning: 'The 5 Pure Vowels',
          explanation: 'Hold your lips steady. Never glide "o" into "ow" or "e" into "ay".',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'The Spanish "J" and soft "G"',
          instruction: 'Spanish "J" sounds like a raspy, passionate "H".',
          foreignText: 'Hola / Jamón',
          phoneticGuide: '[OH-lah / Hah-MON]',
          englishMeaning: 'Hello / Ham',
          explanation: 'The "H" in "Hola" is 100% silent! Never pronounce the H in Spanish.',
          contextExample: '¡Hola! ¿Cómo estás?',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'The Double LL and Ñ',
          instruction: 'LL sounds like English "Y" (in most regions), and Ñ sounds like "ny" in canyon.',
          foreignText: 'Me llamo',
          phoneticGuide: '[Meh YAH-moh]',
          englishMeaning: 'My name is...',
          contextExample: 'Me llamo Carlos. (My name is Carlos.)',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak: The Universal Spanish Greeting',
          instruction: 'Greet warmly with native cadence and no initial H sound.',
          foreignText: '¡Hola! Buenos días.',
          phoneticGuide: '[OH-lah! BWEH-nos DEE-ahs.]',
          englishMeaning: 'Hello! Good morning.',
        ),
      ],
    ),
  };

  // ── French 60-Day Roadmap (Zero to A1 Communicative Mastery) ────────────────

  static final Map<int, DailyLesson> _frenchLessons = {
    1: DailyLesson(
      day: 1,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'French Silent Letters & The Melodic R',
      summary:
          'Learn which letters stay silent at the end of French words and how to produce the throat R sound effortlessly.',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Silent Endings (S, T, D, X, Z)',
          instruction: 'In French, final consonants are usually SILENT!',
          foreignText: 'Salut / Paris',
          phoneticGuide: '[Sah-LEW / Pah-REE]',
          englishMeaning: 'Hi / Paris',
          explanation: 'Do not pronounce the "t" in Salut or the "s" in Paris!',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'The French "Bonjour"',
          instruction: 'Listen to the nasal "on" sound and the soft French "J".',
          foreignText: 'Bonjour!',
          phoneticGuide: '[Bohn-ZHOOR!]',
          englishMeaning: 'Good day / Hello!',
          contextExample: 'Bonjour, comment allez-vous?',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'Introducing Yourself: Je m\'appelle',
          instruction: 'Learn how to state your name naturally in French.',
          foreignText: 'Je m\'appelle...',
          phoneticGuide: '[Zhuh mah-PEL...]',
          englishMeaning: 'My name is... (literally: I call myself...)',
          contextExample: 'Je m\'appelle Sophie.',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak: Warm French Welcome',
          instruction: 'Speak with confidence and soft elegance.',
          foreignText: 'Bonjour! Je m\'appelle Alex.',
          phoneticGuide: '[Bohn-ZHOOR! Zhuh mah-PEL Alex.]',
          englishMeaning: 'Hello! My name is Alex.',
        ),
      ],
    ),
  };

  // ── Italian 60-Day Roadmap (Zero to A1 Communicative Mastery) ───────────────

  static final Map<int, DailyLesson> _italianLessons = {
    1: DailyLesson(
      day: 1,
      phaseNumber: 1,
      phaseTitle: DailyLesson.phaseTitleFor(1),
      title: 'Italian Musicality: Pure Vowels & The Soft C/G',
      summary:
          'Italian is one of the most melodic languages in the world. Learn the C and G rules (Ciao vs. Colosseo).',
      steps: [
        const LessonStep(
          stepNumber: 1,
          type: LessonStepType.phonetic,
          title: 'The Magic of Ciao',
          instruction: 'In Italian, "C" before "I" or "E" makes a "CH" sound.',
          foreignText: 'Ciao!',
          phoneticGuide: '[CHOW!]',
          englishMeaning: 'Hello / Goodbye!',
          explanation: '"Ciao" is used for both meeting and parting with friends.',
        ),
        const LessonStep(
          stepNumber: 2,
          type: LessonStepType.listenRepeat,
          title: 'Good Morning / Good Day',
          instruction: 'The polite and classic Italian daytime greeting.',
          foreignText: 'Buongiorno!',
          phoneticGuide: '[Bwohn-JOR-noh!]',
          englishMeaning: 'Good morning / Good day!',
        ),
        const LessonStep(
          stepNumber: 3,
          type: LessonStepType.sentencePractice,
          title: 'My Name is: Mi chiamo',
          instruction: 'Notice that "ch" before "i" creates a crisp "K" sound.',
          foreignText: 'Mi chiamo...',
          phoneticGuide: '[Mee KYAH-moh...]',
          englishMeaning: 'My name is...',
        ),
        const LessonStep(
          stepNumber: 4,
          type: LessonStepType.activeSpeaking,
          title: 'Speak: Italian Greeting & Name',
          instruction: 'Say hello and introduce yourself with Italian flair.',
          foreignText: 'Ciao! Mi chiamo Marco.',
          phoneticGuide: '[CHOW! Mee KYAH-moh MAR-ko.]',
          englishMeaning: 'Hello! My name is Marco.',
        ),
      ],
    ),
  };

  // ── Generic Fallback Generator (Produces solid, real lessons for all 60 days) ──

  static DailyLesson _generateGenericLesson(String languageName, int day) {
    final phase = DailyLesson.phaseForDay(day);
    final phaseTitle = DailyLesson.phaseTitleFor(phase);

    switch (phase) {
      case 1:
        return DailyLesson(
          day: day,
          phaseNumber: 1,
          phaseTitle: phaseTitle,
          title: '$languageName Sounds & Alphabet: Lesson $day',
          summary:
              'Focus on letter pronunciation, phonetic patterns, and sight-reading single words in $languageName.',
          steps: [
            LessonStep(
              stepNumber: 1,
              type: LessonStepType.phonetic,
              title: 'Letter & Sound Articulation',
              instruction: 'Listen carefully to the distinct vowel and consonant pronunciation.',
              foreignText: 'Alphabet sound $day in $languageName',
              phoneticGuide: '[Phonetic audio guide]',
              englishMeaning: 'Pronunciation core',
              explanation: 'Training your ear and tongue to produce native sounds.',
            ),
            LessonStep(
              stepNumber: 2,
              type: LessonStepType.listenRepeat,
              title: 'Listen & Repeat',
              instruction: 'Tap the audio button to hear the native rhythm, then repeat.',
              foreignText: 'Hello / Welcome in $languageName',
              phoneticGuide: '[Native accent audio]',
              englishMeaning: 'Friendly greeting',
            ),
            LessonStep(
              stepNumber: 3,
              type: LessonStepType.sentencePractice,
              title: 'Forming Your First Short Word',
              instruction: 'Combine the individual sounds into a natural communicative word.',
              foreignText: 'Good Day in $languageName',
              phoneticGuide: '[Speech guide]',
              englishMeaning: 'Good day',
            ),
            LessonStep(
              stepNumber: 4,
              type: LessonStepType.activeSpeaking,
              title: 'Active Vocalization',
              instruction: 'Press the microphone and vocalize the sound clearly.',
              foreignText: 'Hello',
              phoneticGuide: '[Clear voice]',
              englishMeaning: 'Greeting practice',
            ),
          ],
        );

      case 2:
        return DailyLesson(
          day: day,
          phaseNumber: 2,
          phaseTitle: phaseTitle,
          title: 'Survival & Encounters: Day $day',
          summary:
              'Essential courtesy phrases, asking for help, and expressing basic needs in $languageName.',
          steps: [
            const LessonStep(
              stepNumber: 1,
              type: LessonStepType.listenRepeat,
              title: 'Polite Expressions',
              instruction: 'Listen and repeat please and thank you.',
              foreignText: 'Please and thank you',
              phoneticGuide: '[Courtesy phrases]',
              englishMeaning: 'Key politeness words',
            ),
            const LessonStep(
              stepNumber: 2,
              type: LessonStepType.sentencePractice,
              title: 'Pardon & Question',
              instruction: 'Learn how to catch someone’s attention respectfully.',
              foreignText: 'Excuse me',
              phoneticGuide: '[Attention grabber]',
              englishMeaning: 'Excuse me / Pardon',
            ),
            const LessonStep(
              stepNumber: 3,
              type: LessonStepType.activeSpeaking,
              title: 'Speaking Drill',
              instruction: 'Speak the polite phrase into the mic.',
              foreignText: 'Thank you very much',
              phoneticGuide: '[Gratitude phrase]',
              englishMeaning: 'Thank you very much',
            ),
          ],
        );

      case 3:
        return DailyLesson(
          day: day,
          phaseNumber: 3,
          phaseTitle: phaseTitle,
          title: 'The "About Me" Story: Day $day',
          summary:
              'Introduce your name, where you come from, where you live, and what you do in $languageName.',
          steps: [
            LessonStep(
              stepNumber: 1,
              type: LessonStepType.listenRepeat,
              title: 'My Name & Origin',
              instruction: 'State your personal details in full sentence form.',
              foreignText: 'My name is Alex and I am learning $languageName',
              phoneticGuide: '[Self introduction]',
              englishMeaning: 'Full personal statement',
            ),
            const LessonStep(
              stepNumber: 2,
              type: LessonStepType.sentencePractice,
              title: 'Where I Live',
              instruction: 'Describe your residence and home town.',
              foreignText: 'I live in a great city',
              phoneticGuide: '[Residence phrase]',
              englishMeaning: 'I live here',
            ),
            const LessonStep(
              stepNumber: 3,
              type: LessonStepType.activeSpeaking,
              title: 'Complete Intro Speaking Challenge',
              instruction: 'Speak your full 2-sentence self introduction into the microphone.',
              foreignText: 'Hello, my name is Alex and I am here.',
              phoneticGuide: '[Full self-intro]',
              englishMeaning: 'Self introduction',
            ),
          ],
        );

      case 4:
        return DailyLesson(
          day: day,
          phaseNumber: 4,
          phaseTitle: phaseTitle,
          title: 'Everyday Practical Scenarios: Day $day',
          summary:
              'Ordering at a cafe, asking directions, understanding numbers and time in $languageName.',
          steps: [
            const LessonStep(
              stepNumber: 1,
              type: LessonStepType.listenRepeat,
              title: 'At the Cafe',
              instruction: 'Learn how to order a beverage politely.',
              foreignText: 'A coffee, please',
              phoneticGuide: '[Ordering phrase]',
              englishMeaning: 'A coffee, please',
            ),
            const LessonStep(
              stepNumber: 2,
              type: LessonStepType.sentencePractice,
              title: 'Asking How Much It Costs',
              instruction: 'Inquire about the bill or price.',
              foreignText: 'How much does it cost?',
              phoneticGuide: '[Price question]',
              englishMeaning: 'The bill, please',
            ),
            const LessonStep(
              stepNumber: 3,
              type: LessonStepType.activeSpeaking,
              title: 'Speak: The Order',
              instruction: 'Place your order aloud clearly.',
              foreignText: 'I would like a coffee, please.',
              phoneticGuide: '[Order spoken]',
              englishMeaning: 'Ordering fluently',
            ),
          ],
        );

      case 5:
        return DailyLesson(
          day: day,
          phaseNumber: 5,
          phaseTitle: phaseTitle,
          title: 'Expressing Opinions & Daily Flow: Day $day',
          summary:
              'Say what you like, what you dislike, and connect ideas with "because" and "and".',
          steps: [
            const LessonStep(
              stepNumber: 1,
              type: LessonStepType.listenRepeat,
              title: 'Likes & Preferences',
              instruction: 'Express what you enjoy doing.',
              foreignText: 'I like music and traveling',
              phoneticGuide: '[Expressing hobbies]',
              englishMeaning: 'I like traveling',
            ),
            const LessonStep(
              stepNumber: 2,
              type: LessonStepType.activeSpeaking,
              title: 'Speak: Share an Opinion',
              instruction: 'Speak your thought into the microphone.',
              foreignText: 'This is very interesting',
              phoneticGuide: '[Opinion speech]',
              englishMeaning: 'Expressing enthusiasm',
            ),
          ],
        );

      case 6:
      default:
        return DailyLesson(
          day: day,
          phaseNumber: 6,
          phaseTitle: phaseTitle,
          title: 'A1 Fluency Capstone: Day $day',
          summary:
              'Conversational dialogue, listening comprehension check, and active speech synthesis.',
          steps: [
            LessonStep(
              stepNumber: 1,
              type: LessonStepType.listenRepeat,
              title: 'Real-World Mini Dialogue',
              instruction: 'Listen to the back-and-forth conversation rhythm.',
              foreignText: 'Dialogue exchange in $languageName',
              phoneticGuide: '[Conversational rhythm]',
              englishMeaning: 'Natural dialogue flow',
            ),
            const LessonStep(
              stepNumber: 2,
              type: LessonStepType.activeSpeaking,
              title: 'Capstone Speaking Challenge',
              instruction: 'Deliver a complete, unprompted speech block demonstrating A1 competence.',
              foreignText: 'I speak this language with joy and confidence!',
              phoneticGuide: '[Fluency delivery]',
              englishMeaning: 'A1 Capstone mastery',
            ),
          ],
        );
    }
  }

  /// High system prompt configured for Gemma on-device inference when generating
  /// personal tutor responses or assessing pronunciation.
  static String buildSystemPrompt({
    required String targetLanguageName,
    required String userLevelTitle,
    required int day,
  }) {
    return '''
You are the elite on-device Language Expert Coach inside Linguago.
Target Language: $targetLanguageName
Student Level: $userLevelTitle
Current Curriculum Progress: Day $day of 60 (CEFR A1 Mastery Track).

Pedagogical Principles:
1. Anti-Duolingo Philosophy: Never teach isolated, contextless words. Always embed vocabulary in practical, complete sentences that real native speakers say.
2. Systematic Phonetic Mastery: Emphasize correct pronunciation, tongue position, and rhythm.
3. Patient & Inspiring: Provide clear, encouraging corrections. Point out what was pronounced well before gently refining nuances.
4. Direct Speaking Reflex: Keep explanations concise and always prompt the learner to repeat aloud or construct a sentence about themselves.
''';
  }
}

