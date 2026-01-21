import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myprojectshop/core/secrets.dart';

class GeminiService {
  late final GenerativeModel _model;
  final List<Content> _chatHistory = [];

  GeminiService() {
    _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: Secrets.geminiApiKey);
  }

  Future<String> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      _chatHistory.add(content);

      final response = await _model.generateContent(_chatHistory);
      final responseText = response.text;

      if (responseText != null) {
        _chatHistory.add(Content.model([TextPart(responseText)]));
        return responseText;
      } else {
        return "Sorry, I couldn't generate a response.";
      }
    } catch (e) {
      print("Gemini Error: $e");
      return "Error: Unable to connect to AI Assistant. Please check your API Key.";
    }
  }

  void clearHistory() {
    _chatHistory.clear();
  }
}
