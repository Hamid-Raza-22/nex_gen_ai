import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

class AiAgent {
  const AiAgent({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.systemPrompt,
    required this.greeting,
  });

  final String id;
  final String title;
  final String description;
  final String image;
  final String systemPrompt;
  final String greeting;
}

const aiAgents = [
  AiAgent(
    id: 'interview',
    title: 'Interview Practice',
    description: 'Mock interviews with instant feedback',
    image: 'assets/img/ai-agent/interview.webp',
    systemPrompt:
        'You are an experienced technical and behavioural interviewer. Ask the '
        'user one interview question at a time, wait for their answer, then give '
        'concise constructive feedback before the next question.',
    greeting:
        'Welcome to interview practice! What role are you interviewing for?',
  ),
  AiAgent(
    id: 'language',
    title: 'Language Practice',
    description: 'Practise conversation in any language',
    image: 'assets/img/ai-agent/language.webp',
    systemPrompt:
        'You are a friendly language tutor. Hold a natural conversation in the '
        'language the user is learning, gently correct mistakes, and adapt to '
        'their proficiency level.',
    greeting: 'Hi! Which language would you like to practise today?',
  ),
  AiAgent(
    id: 'lecture',
    title: 'Lecture Mode',
    description: 'Deep explanations on any topic',
    image: 'assets/img/ai-agent/lecture.webp',
    systemPrompt:
        'You are a university lecturer. Deliver structured, engaging lectures on '
        'the requested topic with clear sections, examples, and a summary.',
    greeting: 'What topic would you like a lecture on?',
  ),
  AiAgent(
    id: 'meditation',
    title: 'Guided Meditation',
    description: 'Calm, guided mindfulness sessions',
    image: 'assets/img/ai-agent/meditation.webp',
    systemPrompt:
        'You are a calm meditation guide. Lead short guided meditation and '
        'breathing sessions with a soothing, unhurried tone.',
    greeting:
        'Let\'s take a moment to relax. How much time do you have today?',
  ),
  AiAgent(
    id: 'qa',
    title: 'Q&A Assistant',
    description: 'Rapid answers to anything you ask',
    image: 'assets/img/ai-agent/qa.webp',
    systemPrompt:
        'You are a fast, accurate Q&A assistant. Answer questions directly and '
        'concisely, noting uncertainty where it exists.',
    greeting: 'Ask me anything and I\'ll get straight to the answer.',
  ),
];

AiAgent? agentById(String id) {
  for (final a in aiAgents) {
    if (a.id == id) return a;
  }
  return null;
}

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Agents')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: aiAgents.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final agent = aiAgents[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push('/agent-chat/${agent.id}'),
              child: Row(
                children: [
                  Image.asset(
                    agent.image,
                    width: 110,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agent.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            agent.description,
                            style: const TextStyle(
                              color: AppColors.light,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.chevron_right, color: AppColors.mid),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
