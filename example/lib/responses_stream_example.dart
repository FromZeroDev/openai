import 'package:dart_openai/dart_openai.dart';

import 'env/env.dart';

Future<void> main() async {
  // Set the OpenAI API key from the .env file.
  OpenAI.apiKey = Env.apiKey;
  OpenAI.baseUrl = "https://opencode.ai/zen/go";

  // Creates a stream of Responses.
  final responsesStream = OpenAI.instance.responses.createStream(
    model: Env.model,
    input: "Write a short poem about streams.",
  );

  // Accumulates the streamed text.
  final buffer = StringBuffer();

  // Listen to the stream.
  responsesStream.listen(
    (streamResponse) {
      switch (streamResponse.type) {
        case OpenAiStreamResponse.responseCreatedEvent:
          print("Response created: ${streamResponse.id}");
          break;
        case OpenAiStreamResponse.outputTextDeltaEvent:
          // Print the incremental text as it arrives.
          final delta = streamResponse.textDelta?.delta ?? "";
          buffer.write(delta);
          print(delta);
          break;
        case OpenAiStreamResponse.outputTextDoneEvent:
          print("--- Text done: ${streamResponse.textDone?.text}");
          break;
        case OpenAiStreamResponse.responseCompletedEvent:
          print("Completed. Usage: ${streamResponse.response?.usage}");
          break;
        case OpenAiStreamResponse.responseIncompleteEvent:
          print("Incomplete: ${streamResponse.response?.incompleteDetails}");
          break;
        case OpenAiStreamResponse.responseFailedEvent:
          print("Failed: ${streamResponse.response?.error}");
          break;
        case OpenAiStreamResponse.errorEvent:
          print("Error: ${streamResponse.error}");
          break;
      }
    },
    onError: (error) {
      print(error);
    },
    cancelOnError: false,
    onDone: () {
      print("Done");
      print("Full text:\n$buffer");
    },
  );
}
