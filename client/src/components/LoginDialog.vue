<template>
  <div class="login-dialog">
    <div class="login-container">
      <div class="login-header">
        <Icon icon="mdi:account-circle" class="login-icon" />
        <h2>ARPG 游戏登录</h2>
      </div>
      
      <div class="login-form">
        <div class="input-group">
          <Icon icon="mdi:account" class="input-icon" />
          <input
            v-model="account"
            type="text"
            placeholder="账号"
            class="login-input"
            @keyup.enter="handleLogin"
          />
        </div>
        
        <div class="input-group">
          <Icon icon="mdi:lock" class="input-icon" />
          <input
            v-model="password"
            type="password"
            placeholder="密码"
            class="login-input"
            @keyup.enter="handleLogin"
          />
        </div>
        
        <button
          class="login-button"
          :disabled="loading || !account || !password"
          @click="handleLogin"
        >
          <Icon v-if="loading" icon="mdi:loading" class="button-icon spin" />
          <Icon v-else icon="mdi:login" class="button-icon" />
          <span>{{ loading ? '登录中...' : '登录' }}</span>
        </button>
        
        <div v-if="errorMessage" class="error-message">
          <Icon icon="mdi:alert-circle" class="error-icon" />
          {{ errorMessage }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue';
import { useLoginDialog } from './useLoginDialog';

const emit = defineEmits(['login']);

const { account, password, loading, errorMessage, handleLogin } = useLoginDialog(emit);
</script>

<style scoped>
.login-dialog {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  pointer-events: auto;
  z-index: 2000;
}

.login-container {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
  min-width: 350px;
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
  color: white;
}

.login-icon {
  font-size: 48px;
  margin-bottom: 10px;
  color: #64b5f6;
}

.login-header h2 {
  font-size: 24px;
  font-weight: 600;
  margin: 0;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.input-group {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 12px;
  font-size: 20px;
  color: #90caf9;
  z-index: 1;
}

.login-input {
  width: 100%;
  padding: 12px 12px 12px 40px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  font-size: 14px;
  transition: all 0.3s;
}

.login-input::placeholder {
  color: rgba(255, 255, 255, 0.6);
}

.login-input:focus {
  outline: none;
  border-color: #64b5f6;
  background: rgba(255, 255, 255, 0.15);
}

.login-button {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #4caf50 0%, #45a049 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.3s;
  margin-top: 10px;
}

.login-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #45a049 0%, #3d8b40 100%);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
}

.login-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.button-icon {
  font-size: 20px;
}

.spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.error-message {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px;
  background: rgba(244, 67, 54, 0.2);
  border: 1px solid rgba(244, 67, 54, 0.5);
  border-radius: 6px;
  color: #ffcdd2;
  font-size: 14px;
}

.error-icon {
  font-size: 18px;
  color: #f44336;
}
</style>
