import { ref, Ref, nextTick, onMounted } from 'vue';
import { EventBus } from '../core/EventBus';
import { ChatNtf } from '../network/Protocol';

export interface ChatMessage {
  username: string;
  message: string;
}

export function useChatPanel() {
  const messages: Ref<ChatMessage[]> = ref([]);
  const inputMessage: Ref<string> = ref('');
  const expanded: Ref<boolean> = ref(true);
  const messagesContainer: Ref<HTMLElement | null> = ref(null);

  const addMessage = (username: string, message: string): void => {
    messages.value.push({ username, message });

    // 限制消息数量
    if (messages.value.length > 50) {
      messages.value.shift();
    }

    // 自动滚动到底部
    nextTick(() => {
      scrollToBottom();
    });
  };

  const scrollToBottom = (): void => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
    }
  };

  const sendMessage = (): void => {
    const message = inputMessage.value.trim();
    if (!message) return;

    // 通过事件总线发送消息
    const game = (window as any).__game;
    if (game) {
      const eventBus = game.getEventBus();
      if (eventBus) {
        eventBus.emit('chat:send', message);
      }
    }
    inputMessage.value = '';
  };

  const toggleExpanded = (): void => {
    expanded.value = !expanded.value;
  };

  const setupChatListeners = (): void => {
    const game = (window as any).__game;
    if (game) {
      const eventBus: EventBus = game.getEventBus();

      // 监听聊天消息
      eventBus.on('message:CHAT_NTF', (message: ChatNtf) => {
        addMessage(message.username, message.msg);
      });

      eventBus.on('chat:message', (message: ChatNtf) => {
        addMessage(message.username, message.msg);
      });
    }
  };

  // 自动设置监听器
  onMounted(() => {
    setupChatListeners();
  });

  return {
    messages,
    inputMessage,
    expanded,
    messagesContainer,
    sendMessage,
    toggleExpanded,
  };
}
