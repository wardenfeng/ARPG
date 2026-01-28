import { ref, Ref, computed, watch, onMounted, onUnmounted, type Ref as VueRef } from 'vue';
import { AssetPaths } from '../config/AssetPaths';
import { PlayerEntity } from '../scene/entities/PlayerEntity';

export interface MapInfo {
  mapId: number;
  mapWidth: number;
  mapHeight: number;
  smallMapUrl: string;
}

export function useSceneMapPanel() {
  const isVisible: Ref<boolean> = ref(false);
  const mapInfo: Ref<MapInfo | null> = ref(null);
  const playerMapX: Ref<number> = ref(0);
  const playerMapY: Ref<number> = ref(0);
  const cameraX: Ref<number> = ref(0);
  const cameraY: Ref<number> = ref(0);
  const mapImageRef: Ref<HTMLImageElement | null> = ref(null);
  const imageLoaded: Ref<boolean> = ref(false);
  const otherPlayers: Ref<Array<{ playerId: number; username: string; mapX: number; mapY: number }>> = ref([]);
  let updateInterval: number | null = null;

  const toggle = (): void => {
    isVisible.value = !isVisible.value;
    if (isVisible.value) {
      // 检查图片是否已加载（可能已缓存）
      if (mapImageRef.value && mapImageRef.value.complete && mapImageRef.value.naturalWidth > 0) {
        imageLoaded.value = true;
      }
      updateMapInfo();
      // 开始定时更新位置信息
      startUpdateInterval();
    } else {
      // 停止定时更新
      stopUpdateInterval();
    }
  };

  const close = (): void => {
    isVisible.value = false;
    stopUpdateInterval();
  };

  const startUpdateInterval = (): void => {
    stopUpdateInterval(); // 先清除已有的定时器
    updateInterval = window.setInterval(() => {
      if (isVisible.value) {
        updatePosition();
      }
    }, 100); // 每 100ms 更新一次位置
  };

  const stopUpdateInterval = (): void => {
    if (updateInterval !== null) {
      clearInterval(updateInterval);
      updateInterval = null;
    }
  };

  const updatePosition = (): void => {
    const game = (window as any).__game;
    if (!game) {
      return;
    }

    const sceneManager = game.getSceneManager();
    if (!sceneManager) {
      return;
    }

    const mapRenderer = sceneManager.getMapRenderer();
    if (!mapRenderer) {
      return;
    }

    // 更新相机位置（用于显示当前视野范围）
    cameraX.value = mapRenderer.getCameraX();
    cameraY.value = mapRenderer.getCameraY();

    // TODO: 获取玩家位置
    // 目前先使用相机位置作为玩家位置的近似值
    // 后续可以从 PlayerEntity 或事件总线获取真实玩家位置
    playerMapX.value = cameraX.value;
    playerMapY.value = cameraY.value;

    // 更新其他玩家位置
    updateOtherPlayers();
  };

  // 更新其他玩家列表
  const updateOtherPlayers = (): void => {
    const game = (window as any).__game;
    if (!game) {
      otherPlayers.value = [];
      return;
    }

    const sceneManager = game.getSceneManager();
    if (!sceneManager) {
      otherPlayers.value = [];
      return;
    }

    // 获取所有场景项
    const items = sceneManager.getScene().getItems();
    
    // 过滤出玩家实体
    const players: Array<{ playerId: number; username: string; mapX: number; mapY: number }> = [];
    
    for (const item of items) {
      // 检查是否是 PlayerEntity
      if (item instanceof PlayerEntity) {
        // 排除当前玩家（通过位置匹配，如果位置非常接近则认为是当前玩家）
        const distance = Math.sqrt(
          Math.pow(item.getMapX() - playerMapX.value, 2) + 
          Math.pow(item.getMapY() - playerMapY.value, 2)
        );
        
        // 如果距离大于 50，则认为是其他玩家
        if (distance > 50) {
          const mapX = item.getMapX();
          const mapY = item.getMapY();
          players.push({
            playerId: item.playerId,
            username: item.username,
            mapX,
            mapY,
          });
        }
      }
    }
    
    otherPlayers.value = players;
  };

  const updateMapInfo = (): void => {
    const game = (window as any).__game;
    if (!game) {
      console.warn('Game instance not found');
      return;
    }

    const sceneManager = game.getSceneManager();
    if (!sceneManager) {
      console.warn('SceneManager not found');
      return;
    }

    const mapRenderer = sceneManager.getMapRenderer();
    if (!mapRenderer) {
      console.warn('MapRenderer not found');
      return;
    }

    const config = mapRenderer.getConfig();
    if (!config) {
      console.warn('Map config not found');
      return;
    }

    // 更新地图信息
    mapInfo.value = {
      mapId: config.mapId,
      mapWidth: config.mapWidth,
      mapHeight: config.mapHeight,
      smallMapUrl: AssetPaths.getSmallMapPath(config.mapId),
    };

    // 检查图片是否已加载（可能已缓存，不会触发 load 事件）
    // 使用 nextTick 确保 DOM 已更新
    setTimeout(() => {
      if (mapImageRef.value && mapImageRef.value.complete && mapImageRef.value.naturalWidth > 0) {
        imageLoaded.value = true;
      }
      // 更新位置信息
      updatePosition();
    }, 50);
  };

  // 获取图片在容器中的实际显示尺寸和位置（考虑 object-fit: contain）
  const getImageDisplayInfo = (): { 
    displayWidth: number; 
    displayHeight: number; 
    offsetX: number; 
    offsetY: number;
    containerWidth: number;
    containerHeight: number;
  } | null => {
    if (!mapImageRef.value || !mapInfo.value) {
      return null;
    }

    const img = mapImageRef.value;
    const naturalWidth = img.naturalWidth || 0;
    const naturalHeight = img.naturalHeight || 0;
    const containerWidth = img.clientWidth || 0;
    const containerHeight = img.clientHeight || 0;

    if (naturalWidth === 0 || naturalHeight === 0 || containerWidth === 0 || containerHeight === 0) {
      return null;
    }

    // 计算缩放比例（保持宽高比，类似 object-fit: contain）
    const scaleX = containerWidth / naturalWidth;
    const scaleY = containerHeight / naturalHeight;
    const scale = Math.min(scaleX, scaleY);

    // 计算实际显示尺寸
    const displayWidth = naturalWidth * scale;
    const displayHeight = naturalHeight * scale;

    // 计算偏移量（图片在容器中居中）
    const offsetX = (containerWidth - displayWidth) / 2;
    const offsetY = (containerHeight - displayHeight) / 2;

    return {
      displayWidth,
      displayHeight,
      offsetX,
      offsetY,
      containerWidth,
      containerHeight,
    };
  };

  // 计算指定位置在小地图上的位置（基于图片实际显示尺寸）
  const getPositionOnMap = (mapX: number, mapY: number): { x: number; y: number } => {
    const displayInfo = getImageDisplayInfo();
    if (!displayInfo) {
      return { x: 0, y: 0 };
    }

    // 计算缩放比例（图片显示尺寸 / 地图尺寸）
    const mapScaleX = displayInfo.displayWidth / mapInfo.value!.mapWidth;
    const mapScaleY = displayInfo.displayHeight / mapInfo.value!.mapHeight;

    // 计算指定位置在图片显示区域中的像素位置
    const pixelX = mapX * mapScaleX;
    const pixelY = mapY * mapScaleY;

    // 转换为相对于容器的百分比（包括偏移量）
    const x = ((displayInfo.offsetX + pixelX) / displayInfo.containerWidth) * 100;
    const y = ((displayInfo.offsetY + pixelY) / displayInfo.containerHeight) * 100;

    return { x, y };
  };

  // 计算玩家在小地图上的位置（基于图片实际显示尺寸）
  const getPlayerPosition = (): { x: number; y: number } => {
    return getPositionOnMap(playerMapX.value, playerMapY.value);
  };

  // 计算其他玩家在小地图上的位置列表
  const getOtherPlayersPositions = computed(() => {
    if (!imageLoaded.value || !mapImageRef.value || !mapInfo.value) {
      return [];
    }

    return otherPlayers.value.map(player => ({
      playerId: player.playerId,
      username: player.username,
      position: getPositionOnMap(player.mapX, player.mapY),
    }));
  });

  // 计算当前视野在小地图上的位置和大小（基于图片实际显示尺寸）
  const getViewportRect = (): { x: number; y: number; width: number; height: number } => {
    const displayInfo = getImageDisplayInfo();
    if (!displayInfo) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }

    const game = (window as any).__game;
    if (!game) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }

    const sceneManager = game.getSceneManager();
    if (!sceneManager) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }

    const mapRenderer = sceneManager.getMapRenderer();
    if (!mapRenderer) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }

    // 计算缩放比例（图片显示尺寸 / 地图尺寸）
    const mapScaleX = displayInfo.displayWidth / mapInfo.value!.mapWidth;
    const mapScaleY = displayInfo.displayHeight / mapInfo.value!.mapHeight;

    // 从 MapRenderer 获取实际的视野尺寸（游戏世界坐标）
    const viewWidth = mapRenderer.getViewWidth();
    const viewHeight = mapRenderer.getViewHeight();

    if (viewWidth === 0 || viewHeight === 0) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }

    // 计算视野在图片显示区域中的像素位置和大小
    const pixelX = cameraX.value * mapScaleX;
    const pixelY = cameraY.value * mapScaleY;
    const pixelWidth = viewWidth * mapScaleX;
    const pixelHeight = viewHeight * mapScaleY;

    // 转换为相对于容器的百分比（包括偏移量）
    const x = ((displayInfo.offsetX + pixelX) / displayInfo.containerWidth) * 100;
    const y = ((displayInfo.offsetY + pixelY) / displayInfo.containerHeight) * 100;
    const width = (pixelWidth / displayInfo.containerWidth) * 100;
    const height = (pixelHeight / displayInfo.containerHeight) * 100;

    return { x, y, width, height };
  };

  // 监听键盘事件
  const handleKeyDown = (event: KeyboardEvent): void => {
    // 按 M 键切换地图显示
    if (event.key === 'm' || event.key === 'M') {
      // 避免在输入框中触发
      const target = event.target as HTMLElement;
      if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') {
        return;
      }
      event.preventDefault();
      toggle();
    }

    // 按 ESC 键关闭地图
    if (event.key === 'Escape' && isVisible.value) {
      event.preventDefault();
      close();
    }
  };

  // 处理窗口大小变化，实时更新视野尺寸
  const handleResize = (): void => {
    if (isVisible.value) {
      // 触发更新，让 computed 属性重新计算（包括图片尺寸变化）
      updatePosition();
    }
  };

  onMounted(() => {
    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('resize', handleResize);
  });

  onUnmounted(() => {
    window.removeEventListener('keydown', handleKeyDown);
    window.removeEventListener('resize', handleResize);
    stopUpdateInterval();
  });

  // 计算属性：玩家位置和视野范围（依赖 mapImageRef 和 imageLoaded 以确保响应式更新）
  const playerPosition = computed(() => {
    // 访问响应式变量以确保追踪
    const img = mapImageRef.value;
    const loaded = imageLoaded.value;
    
    if (!loaded || !img || !mapInfo.value) {
      return { x: 0, y: 0 };
    }
    
    return getPlayerPosition();
  });
  const viewportRect = computed(() => {
    // 访问响应式变量以确保追踪
    const img = mapImageRef.value;
    const loaded = imageLoaded.value;
    
    if (!loaded || !img || !mapInfo.value) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }
    
    return getViewportRect();
  });

  // 计算属性：确保类型安全的地图信息
  const smallMapUrl = computed(() => mapInfo.value?.smallMapUrl || '');
  const mapId = computed(() => mapInfo.value?.mapId || 0);

  // 计算样式对象：视野指示器样式
  const viewportStyle = computed(() => {
    const rect = viewportRect.value;
    return {
      left: `${rect.x}%`,
      top: `${rect.y}%`,
      width: `${rect.width}%`,
      height: `${rect.height}%`,
    };
  });

  // 计算样式对象：玩家位置指示器样式
  const playerStyle = computed(() => {
    const pos = playerPosition.value;
    return {
      left: `${pos.x}%`,
      top: `${pos.y}%`,
    };
  });

  // 格式化玩家位置显示
  const playerPositionText = computed(() => {
    return `(${Math.floor(playerMapX.value)}, ${Math.floor(playerMapY.value)})`;
  });

  // 计算玩家总数（包括当前玩家和其他玩家）
  const playerCount = computed(() => {
    // 当前玩家 + 其他玩家数量
    return 1 + otherPlayers.value.length;
  });

  // 当地图显示时，更新地图信息
  watch(isVisible, (newValue) => {
    if (newValue) {
      // 重置图片加载状态，等待重新检查
      imageLoaded.value = false;
      updateMapInfo();
    }
  });

  // 设置地图图片引用
  const setMapImageRef = (imageRef: VueRef<HTMLImageElement | null>): void => {
    // 监听 ref 变化，更新内部引用
    watch(imageRef, (newValue) => {
      mapImageRef.value = newValue;
      // 如果图片已经加载，标记为已加载
      if (newValue && newValue.complete && newValue.naturalWidth > 0) {
        imageLoaded.value = true;
      }
    }, { immediate: true });
  };

  // 处理地图图片加载完成
  const handleImageLoad = (): void => {
    // 标记图片已加载
    imageLoaded.value = true;
    // 图片加载完成后，触发视野区域重新计算
    if (isVisible.value) {
      // 延迟一下确保图片尺寸已更新
      setTimeout(() => {
        updatePosition();
      }, 50);
    }
  };

  // 处理地图图片加载错误
  const handleImageError = (event: Event): void => {
    console.error('Failed to load map image:', event);
    const img = event.target as HTMLImageElement;
    img.style.display = 'none';
  };

  return {
    isVisible,
    mapInfo,
    playerMapX,
    playerMapY,
    toggle,
    close,
    updateMapInfo,
    getPlayerPosition,
    getViewportRect,
    // 计算属性
    playerPosition,
    viewportRect,
    smallMapUrl,
    mapId,
    viewportStyle,
    playerStyle,
    playerPositionText,
    playerCount,
    // 其他玩家
    otherPlayers,
    getOtherPlayersPositions,
    // 事件处理
    setMapImageRef,
    handleImageLoad,
    handleImageError,
  };
}

