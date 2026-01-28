<template>
  <div id="app">
    <LoginDialog
      v-if="!isLoggedIn"
      @login="handleLogin"
    />
    <ChatPanel
      v-if="isLoggedIn"
    />
    <SceneMapPanel
      v-if="isLoggedIn"
    />
  </div>
</template>

<script setup lang="ts">
import LoginDialog from './components/LoginDialog.vue';
import ChatPanel from './components/ChatPanel.vue';
import SceneMapPanel from './components/SceneMapPanel.vue';
import { useApp } from './useApp';

const { isLoggedIn, handleLogin } = useApp();
</script>

<style scoped>
#app {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 1000;
}
</style>
