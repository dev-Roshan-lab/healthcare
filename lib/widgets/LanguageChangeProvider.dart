import 'package:translator/translator.dart';



  Future<String> translate(String message, String fromLanguageCode, String toLanguage)
  async {
    final translation = await GoogleTranslator().translate(message,from: fromLanguageCode,to: toLanguage);
    return translation.text;
  }
