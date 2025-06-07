import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:project_one/models/madical_records.dart';
import 'package:project_one/models/pet_profile.dart';
import 'package:project_one/models/vaccine.dart';



class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String apiKey = 'AIzaSyCspN5hm5scWgtfL7ao7Q9scFj1m9NLKWc';
  late final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message['sender'] == 'You';

                      return Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container( 
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUser
                                  ? const Radius.circular(16)
                                  : const Radius.circular(0),
                              bottomRight: isUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(width: 12),
                        Text("Bot is typing...",
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({'text': question, 'sender': 'You'});
      _isLoading = true;
    });

    _controller.clear();

    final reply = await getSmartReplyFromGemini(question);

    setState(() {
      _messages.add({'text': reply, 'sender': 'Bot'});
      _isLoading = false;
    });
  }

  Future<Map<String, dynamic>> getUserDomainData() async {
    final PetProfileController petController = PetProfileController();
    final petProfile = await petController.getPetProfile();

    final medicalRecordStream = MedicalRecordController().getUserMedicalRecords();
    final medicalRecordsSnapshot = await medicalRecordStream.first;

    User? user = FirebaseAuth.instance.currentUser;
    final VaccineControllers vaccineControllers = VaccineControllers();
    final vaccineStream = vaccineControllers.getVaccinesByUserId(user!.uid);
    final vaccinesSnapshot = await vaccineStream.first;

    return {
      'petProfile': petProfile?.toMap() ?? {},
      'medicalRecords': medicalRecordsSnapshot,
      'vaccines': vaccinesSnapshot,
    };
  }

  Future<String> getSmartReplyFromGemini(String userPrompt) async {
    // Get user data
    final domainData = await getUserDomainData();
    final petProfile = domainData['petProfile'];
    final medicalRecords = domainData['medicalRecords'];
    final vaccines = domainData['vaccines'];

    // Build the context for the chatbot based on the user data
    String context = "Pet Info:\n";
    if (petProfile.isNotEmpty) {
      context +=
          "Name: ${petProfile['name']}, Breed: ${petProfile['breed']}, Type: ${petProfile['type']}, Age: ${petProfile['age']}, Weight: ${petProfile['weight']}kg, Height: ${petProfile['height']}m.\n";
    }

    context += "\nMedical Records:\n";
    for (var record in medicalRecords) {
      context +=
          "Virus: ${record.virus}, Vet Name: ${record.vetName}, Type: ${record.type}, Date: ${record.date}, Purpose: ${record.purpose}, Comment: ${record.comment}, Expires: ${record.expires}\n";
    }

    context += "\nVaccines:\n";
    for (var vaccine in vaccines) {
      context +=
          "Vaccine: ${vaccine.name}, Type: ${vaccine.type}, Administered Date: ${vaccine.administeredDate}, Expiry Date: ${vaccine.expiredDate}, Weight: ${vaccine.weight}kg, Vet: ${vaccine.vetName}, Vet Phone: ${vaccine.vetPhoneNumber}\n";
    }

    String finalPrompt =
        "Based on the following pet medical data:\n$context\n\nUser question: $userPrompt\n\nRespond in simple English with a useful suggestion for the owner.";

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": finalPrompt}
          ]
        }
      ]
    });

    // Make the API request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        return reply.trim();
      } else {
        return 'Error getting reply: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to get reply: $e';
    }
  }

}
