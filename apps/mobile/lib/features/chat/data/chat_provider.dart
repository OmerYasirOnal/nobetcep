import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/chat_message.dart';
import '../../../core/services/api_service.dart';

/// Chat state
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? conversationId;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.conversationId,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? conversationId,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      conversationId: conversationId ?? this.conversationId,
      error: error,
    );
  }
}

/// Chat provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  /// Send a message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // Call API
      final response = await ApiService.instance.post(
        '/llm/chat',
        data: {
          'message': content,
          'conversation_id': state.conversationId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        final botMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: data['response'] as String,
          isUser: false,
          timestamp: DateTime.now(),
          hasDisclaimer: data['has_disclaimer'] as bool? ?? false,
        );

        state = state.copyWith(
          messages: [...state.messages, botMessage],
          isLoading: false,
          conversationId: data['conversation_id'] as String?,
        );
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local responses if API fails
      final botMessage = _getLocalResponse(content);

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
      );
    }
  }

  /// Clear chat history
  void clearChat() {
    state = const ChatState();
  }

  /// Get local fallback response
  ChatMessage _getLocalResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    String response;
    bool hasDisclaimer = false;

    // Check for medical advice requests
    if (_containsMedicalAdviceRequest(message)) {
      response = 'Bu konuda size yardımcı olmak isterim, ancak dozaj ve tedavi '
          'önerileri vermem uygun olmaz. Lütfen bu konuda doktorunuza '
          'veya eczacınıza danışın. 👨‍⚕️\n\n'
          'Size şu konularda yardımcı olabilirim:\n'
          '• İlaçların genel bilgileri\n'
          '• Yan etki bilgilendirmesi\n'
          '• Nöbetçi eczane bulma\n'
          '• İlaç hatırlatma ayarlama';
      hasDisclaimer = true;
    } else if (message.contains('eczane') || message.contains('nöbetçi')) {
      response = 'Nöbetçi eczane bulmak için ana ekrandaki "Nöbetçi Eczane" '
          'butonunu kullanabilirsiniz. Konumunuzu paylaşırsanız '
          'size en yakın nöbetçi eczaneleri gösterebilirim. 📍';
    } else if (message.contains('hatırlat') || message.contains('alarm')) {
      response = 'İlaç hatırlatmalarınızı ayarlamak için "İlaçlarım" sekmesine '
          'gidin ve "+" butonuyla yeni ilaç ekleyin. Sabit saat veya '
          'aralıklı hatırlatma seçenekleri mevcut. ⏰';
    } else if (message.contains('merhaba') ||
        message.contains('selam') ||
        message.contains('hey')) {
      response = 'Merhaba! 👋 Size nöbetçi eczane bulma, ilaç hatırlatmaları '
          've genel ilaç bilgileri konusunda yardımcı olabilirim. '
          'Ne öğrenmek istersiniz?';
    } else {
      response = 'Size nöbetçi eczane bulma, ilaç hatırlatmaları '
          've genel ilaç bilgileri konusunda yardımcı olabilirim. '
          'Ne öğrenmek istersiniz? 💊';
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
      hasDisclaimer: hasDisclaimer,
    );
  }

  /// Check if message asks for medical advice
  bool _containsMedicalAdviceRequest(String message) {
    final keywords = [
      'dozaj',
      'doz',
      'kaç mg',
      'kaç tablet',
      'ne kadar almalı',
      'teşhis',
      'tanı koy',
      'hastalığım ne',
      'hangi ilacı',
      'reçete',
      'tedavi',
    ];
    return keywords.any((keyword) => message.contains(keyword));
  }
}
