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

    console.log('Sending chat message:', message);

    // 通过事件总线发送消息
    const game = (window as any).__game;
    if (game) {
      const eventBus = game.getEventBus();
      if (eventBus) {
        eventBus.emit('chat:send', message);
        console.log('Chat message sent via event bus');
      } else {
        console.error('EventBus not found');
      }
    } else {
      console.error('Game instance not found');
    }
    inputMessage.value = '';
  };

  const toggleExpanded = (): void => {
    expanded.value = !expanded.value;
  };

  const setupChatListeners = (): void => {
    // 延迟设置监听器，确保游戏已初始化
    let retryCount = 0;
    const maxRetries = 50; // 最多重试 5 秒
    
    const trySetup = () => {
      const game = (window as any).__game;
      if (game) {
        const eventBus: EventBus = game.getEventBus();

        // 只监听 chat:message 事件（MessageHandler.handleChatNtf 发出的）
        // 不监听 message:CHAT_NTF，避免重复接收
        const handler = (message: ChatNtf) => {
          console.log('useChatPanel: Received chat:message event:', message);
          addMessage(message.username, message.msg);
        };

        eventBus.on('chat:message', handler);

        console.log('useChatPanel: Chat listeners setup complete');
      } else {
        retryCount++;
        if (retryCount < maxRetries) {
          // 如果游戏还未初始化，延迟重试
          setTimeout(trySetup, 100);
        } else {
          console.error('useChatPanel: Failed to setup listeners after max retries');
        }
      }
    };

    trySetup();
  };

  // 自动设置监听器
  onMounted(() => {
    // 延迟设置，确保游戏已初始化
    setTimeout(() => {
      setupChatListeners();
    }, 500);
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
