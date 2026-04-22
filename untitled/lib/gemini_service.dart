import 'package:google_generative_ai/google_generative_ai.dart';
import 'device_location.dart';
import '.API_KEY/api_key.dart';

enum AssistantMode { route, safety, report, general }

class GeminiService {
  final String _apiKey = api_Key;
  final String _modelName = 'gemini-flash-latest'; 
  late final GenerativeModel _model;

  GeminiService() {
    if (_apiKey.isEmpty) {
      print("Error: Gemini API Key is missing!");
    }
    // Updated model parameter
    _model = GenerativeModel(model: _modelName, apiKey: _apiKey);
  }
  Future<String> getAssistantResponse({
    required String userInput,
    required AssistantMode mode,
    required LocationProvider location,
  }) async {
    String systemPrompt = "Current User Location: ${location.currentLocation.latitude}, ${location.currentLocation.longitude}. ";

    // Logic to change behavior based on the calling file
    switch (mode) {
      case AssistantMode.route:
        systemPrompt += "You are a safety navigation expert. Suggest well-lit, busy routes.";
        break;
      case AssistantMode.safety:
        systemPrompt += "Analyze area safety based on historical mock data and local surroundings.";
        break;
      case AssistantMode.report:
        systemPrompt += "Help the user format a safety report for the community.";
        break;
      default:
        systemPrompt += "You are Amar ProtikKha's general safety assistant.";
    }

    final content = [Content.text("$systemPrompt\nUser Message: $userInput")];
    final response = await _model.generateContent(content);
    
    return response.text ?? "I'm having trouble connecting right now.";
  }
}