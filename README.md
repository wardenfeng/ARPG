# ARPG Game - TypeScript 重构版本

这是一个使用 TypeScript/Node.js 重构的 ARPG 游戏项目，使用 Vite 构建、原生 WebGL 渲染、JSON 协议通信和 WebSocket 多人同步。

## 项目结构

```
项目根目录/
├── client/          # 前端项目（Vite + TypeScript + WebGL）
├── server/          # 后端项目（Node.js + TypeScript + WebSocket）
└── ARPG/            # 原始项目（不修改）
```

## 技术栈

### 客户端
- **构建工具**: Vite
- **语言**: TypeScript
- **渲染**: 原生 WebGL
- **通信**: WebSocket (原生)
- **资源加载**: Fetch API

### 服务端
- **运行时**: Node.js
- **语言**: TypeScript
- **WebSocket**: `ws` 库
- **数据库**: JSON 文件 (fs 模块)

## 安装和运行

### 1. 安装依赖

```bash
# 在根目录执行
npm install
```

### 2. 启动开发服务器

```bash
# 同时启动客户端和服务端
npm run dev

# 或分别启动
npm run dev:client  # 客户端 (http://localhost:5173)
npm run dev:server  # 服务端 (ws://localhost:8887)
```

### 3. 构建项目

```bash
npm run build
```

## 功能特性

- ✅ 登录系统（自动注册）
- ✅ 地图渲染（瓦片地图）
- ✅ 玩家移动（点击移动、A* 寻路）
- ✅ 技能系统（技能释放、伤害计算）
- ✅ 聊天系统
- ✅ 多人同步（玩家添加/移除、位置同步）
- ✅ NPC 和怪物系统（基础结构）

## 开发说明

### 客户端入口
- `client/src/main.ts` - 游戏初始化入口

### 服务端入口
- `server/src/server.ts` - 服务器启动入口

### 数据存储
- 玩家数据：`server/data/players.json`
- 怪物数据：`server/data/monsters.json`

## 注意事项

1. 首次运行会自动创建数据文件
2. 登录时如果账号不存在会自动注册
3. 地图资源需要放在 `client/public/assets/` 目录
4. WebSocket 服务器默认端口：8887
5. Vite 开发服务器默认端口：5173
