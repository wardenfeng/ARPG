<template>
  <div class="chat-panel">
    <div class="chat-header" @click="toggleExpanded">
      <Icon icon="mdi:chat" class="header-icon" />
      <span class="header-title">聊天</span>
      <Icon
        :icon="expanded ? 'mdi:chevron-down' : 'mdi:chevron-up'"
        class="header-toggle"
      />
    </div>
    
    <div v-if="expanded" class="chat-content">
      <div class="chat-messages" ref="messagesContainer">
        <div
          v-for="(msg, index) in messages"
          :key="index"
          class="chat-message"
        >
          <Icon icon="mdi:account-circle" class="message-icon" />
          <div class="message-content">
            <span class="message-username">{{ msg.username }}:</span>
            <span class="message-text">{{ msg.message }}</span>
          </div>
        </div>
        <div v-if="messages.length === 0" class="empty-message">
          <Icon icon="mdi:chat-outline" class="empty-icon" />
          <span>暂无消息</span>
        </div>
      </div>
      
      <div class="chat-input-container">
        <div class="input-wrapper">
          <input
            ref="inputRef"
            v-model="inputMessage"
            type="text"
            placeholder="输入消息..."
            class="chat-input"
            @keyup.enter="sendMessage"
            @blur="handleInputBlur"
          />
          <button class="emoji-button" @click="toggleEmojiPicker" type="button">
            <Icon icon="mdi:emoticon-happy" class="emoji-icon" />
          </button>
        </div>
        <button class="send-button" @click="sendMessage" :disabled="!inputMessage.trim()">
          <Icon icon="mdi:send" class="send-icon" />
        </button>
        <div v-if="showEmojiPicker" class="emoji-picker" @click.stop>
          <div class="emoji-picker-header">
            <span class="emoji-picker-title">选择表情</span>
            <button class="emoji-picker-close" @click="closeEmojiPicker" type="button">
              <Icon icon="mdi:close" class="close-icon" />
            </button>
          </div>
          <div class="emoji-list">
            <button
              v-for="(emoji, index) in emojiList"
              :key="index"
              class="emoji-item"
              @click="insertEmoji(emoji)"
              type="button"
            >
              {{ emoji }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue';
import { useChatPanel } from './useChatPanel';

const {
  messages,
  inputMessage,
  expanded,
  messagesContainer,
  sendMessage,
  toggleExpanded,
  showEmojiPicker,
  inputRef,
  emojiList,
  toggleEmojiPicker,
  insertEmoji,
  closeEmojiPicker,
} = useChatPanel();

// 处理输入框失焦，延迟关闭表情选择器以允许点击表情
const handleInputBlur = () => {
  setTimeout(() => {
    if (showEmojiPicker.value) {
      closeEmojiPicker();
    }
  }, 200);
};

</script>

<style scoped>
.chat-panel {
  position: fixed;
  bottom: 20px;
  left: 20px;
  width: 350px;
  background: rgba(0, 0, 0, 0.85);
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
  pointer-events: auto;
  z-index: 100;
  overflow: hidden;
  transition: all 0.3s;
}

.chat-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 15px;
  background: rgba(30, 60, 114, 0.9);
  cursor: pointer;
  user-select: none;
  transition: background 0.2s;
}

.chat-header:hover {
  background: rgba(30, 60, 114, 1);
}

.header-icon {
  font-size: 20px;
  color: #64b5f6;
}

.header-title {
  flex: 1;
  color: white;
  font-weight: 600;
  font-size: 14px;
}

.header-toggle {
  font-size: 20px;
  color: #90caf9;
  transition: transform 0.3s;
}

.chat-content {
  display: flex;
  flex-direction: column;
  height: 300px;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.chat-message {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  padding: 6px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 6px;
  transition: background 0.2s;
}

.chat-message:hover {
  background: rgba(255, 255, 255, 0.1);
}

.message-icon {
  font-size: 18px;
  color: #64b5f6;
  flex-shrink: 0;
  margin-top: 2px;
}

.message-content {
  flex: 1;
  color: white;
  font-size: 13px;
  line-height: 1.4;
  word-wrap: break-word;
}

.message-username {
  color: #90caf9;
  font-weight: 600;
  margin-right: 6px;
}

.message-text {
  color: rgba(255, 255, 255, 0.9);
}

.empty-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 40px 20px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}

.empty-icon {
  font-size: 48px;
  color: rgba(255, 255, 255, 0.3);
}

.chat-input-container {
  position: relative;
  display: flex;
  gap: 8px;
  padding: 10px;
  background: rgba(0, 0, 0, 0.3);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.input-wrapper {
  position: relative;
  flex: 1;
  display: flex;
  align-items: center;
}

.chat-input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 13px;
  transition: all 0.2s;
}

.chat-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.chat-input:focus {
  outline: none;
  border-color: #64b5f6;
  background: rgba(255, 255, 255, 0.15);
}

.send-button {
  padding: 8px 12px;
  background: linear-gradient(135deg, #4caf50 0%, #45a049 100%);
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.send-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #45a049 0%, #3d8b40 100%);
  transform: scale(1.05);
}

.send-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.send-icon {
  font-size: 18px;
}

.emoji-button {
  position: absolute;
  right: 8px;
  padding: 4px;
  background: transparent;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.7);
  transition: color 0.2s;
  z-index: 1;
}

.emoji-button:hover {
  color: #64b5f6;
}

.emoji-icon {
  font-size: 20px;
}

.emoji-picker {
  position: absolute;
  bottom: 100%;
  left: 10px;
  right: 80px;
  max-height: 200px;
  background: rgba(30, 30, 40, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
  z-index: 1000;
  margin-bottom: 8px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.emoji-picker-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.emoji-picker-title {
  color: white;
  font-size: 12px;
  font-weight: 600;
}

.emoji-picker-close {
  padding: 4px;
  background: transparent;
  border: none;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s;
}

.emoji-picker-close:hover {
  color: white;
}

.close-icon {
  font-size: 16px;
}

.emoji-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 4px;
  max-height: 160px;
}

.emoji-list::-webkit-scrollbar {
  width: 6px;
}

.emoji-list::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.emoji-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.emoji-list::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.emoji-item {
  padding: 6px;
  background: transparent;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 20px;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.emoji-item:hover {
  background: rgba(255, 255, 255, 0.1);
}
</style>
