<template>
  <div v-if="isVisible" class="scene-map-panel" @click.self="close">
    <div class="scene-map-container" @click.stop>
      <div class="scene-map-header">
        <Icon icon="mdi:map" class="header-icon" />
        <span class="header-title">场景地图</span>
        <button class="close-button" @click="close" type="button">
          <Icon icon="mdi:close" class="close-icon" />
        </button>
      </div>
      
      <div class="scene-map-content">
        <div v-if="mapInfo" class="map-wrapper">
          <img
            ref="mapImageRef"
            :src="smallMapUrl"
            :alt="`地图 ${mapId}`"
            class="map-image"
            @error="handleImageError"
            @load="handleImageLoad"
          />
          
          <div
            v-if="viewportRect.width > 0"
            class="viewport-indicator"
            :style="viewportStyle"
          ></div>
          
          <div
            class="player-indicator"
            :style="playerStyle"
          >
            <Icon icon="mdi:map-marker" class="player-marker" />
          </div>
        </div>
        
        <div v-else class="loading-message">
          <Icon icon="mdi:loading" class="loading-icon spin" />
          <span>加载地图中...</span>
        </div>
        
        <div v-if="mapInfo" class="map-info">
          <div class="info-item">
            <Icon icon="mdi:map-marker" class="info-icon" />
            <span>地图ID: {{ mapInfo.mapId }}</span>
          </div>
          <div class="info-item">
            <Icon icon="mdi:arrow-expand" class="info-icon" />
            <span>尺寸: {{ mapInfo.mapWidth }} × {{ mapInfo.mapHeight }}</span>
          </div>
          <div class="info-item">
            <Icon icon="mdi:account" class="info-icon" />
            <span>位置: {{ playerPositionText }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { Icon } from '@iconify/vue';
import { useSceneMapPanel } from './useSceneMapPanel';

const mapImageRef = ref<HTMLImageElement | null>(null);

const {
  isVisible,
  mapInfo,
  close,
  smallMapUrl,
  mapId,
  viewportRect,
  viewportStyle,
  playerStyle,
  playerPositionText,
  handleImageError,
  setMapImageRef,
  handleImageLoad,
} = useSceneMapPanel();

// 将图片引用传递给 composable
setMapImageRef(mapImageRef);
</script>

<style scoped>
.scene-map-panel {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  pointer-events: auto;
}

.scene-map-container {
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  background: rgba(20, 30, 50, 0.95);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  pointer-events: auto;
}

.scene-map-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: rgba(30, 60, 114, 0.9);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-icon {
  font-size: 24px;
  color: #64b5f6;
}

.header-title {
  flex: 1;
  color: white;
  font-weight: 600;
  font-size: 18px;
}

.close-button {
  padding: 6px;
  background: transparent;
  border: none;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s, background 0.2s;
  border-radius: 4px;
}

.close-button:hover {
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

.close-icon {
  font-size: 20px;
}

.scene-map-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.map-wrapper {
  position: relative;
  width: 100%;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  overflow: hidden;
  aspect-ratio: 16 / 9;
  min-height: 400px;
}

.map-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
}

.viewport-indicator {
  position: absolute;
  border: 2px solid #64b5f6;
  background: rgba(100, 181, 246, 0.1);
  pointer-events: none;
  box-sizing: border-box;
}

.player-indicator {
  position: absolute;
  transform: translate(-50%, -50%);
  pointer-events: none;
  z-index: 10;
}

.player-marker {
  font-size: 24px;
  color: #ff5252;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.5));
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.8;
  }
}

.loading-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  padding: 60px 20px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
}

.loading-icon {
  font-size: 48px;
  color: #64b5f6;
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

.map-info {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  padding: 12px;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 6px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.info-icon {
  font-size: 18px;
  color: #64b5f6;
}

.scene-map-content::-webkit-scrollbar {
  width: 8px;
}

.scene-map-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.scene-map-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

.scene-map-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}
</style>

