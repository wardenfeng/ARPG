// Message Types
export enum MessageType {
  // Login
  LOGIN_REQ = 'LOGIN_REQ',
  LOGIN_ACK = 'LOGIN_ACK',
  
  // Movement
  MOVE_REQ = 'MOVE_REQ',
  MOVE_ACK = 'MOVE_ACK',
  MOVE_NTF = 'MOVE_NTF',
  
  // Player
  ADD_PLAYER_NTF = 'ADD_PLAYER_NTF',
  REMOVE_PLAYER_NTF = 'REMOVE_PLAYER_NTF',
  
  // Skill
  CAST_SKILL_REQ = 'CAST_SKILL_REQ',
  CAST_SKILL_ACK = 'CAST_SKILL_ACK',
  CAST_SKILL_NTF = 'CAST_SKILL_NTF',
  
  // HP/MP
  HP_UPDATE_NTF = 'HP_UPDATE_NTF',
  MP_UPDATE_NTF = 'MP_UPDATE_NTF',
  
  // Monster
  ADD_MONSTER_NTF = 'ADD_MONSTER_NTF',
  
  // Chat
  CHAT_REQ = 'CHAT_REQ',
  CHAT_NTF = 'CHAT_NTF',
}

// Enums
export enum LoginResult {
  SUCCEED = 'SUCCEED',
  FAIL = 'FAIL',
  NO_REGISTER = 'NO_REGISTER',
  PASSWORD_ERROR = 'PASSWORD_ERROR',
}

export enum MoveResult {
  SUCCEED = 'SUCCEED',
  FAIL = 'FAIL',
}

export enum AttackType {
  PLAYER = 'PLAYER',
  POINT = 'POINT',
}

export enum ObjectType {
  PLAYER = 'PLAYER',
  MONSTER = 'MONSTER',
  NPC = 'NPC',
}

export enum CastSkillResult {
  SUCCEED = 'SUCCEED',
  FAIL = 'FAIL',
}

// Message Interfaces
export interface LoginReq {
  type: MessageType.LOGIN_REQ;
  account: string;
  password: string;
}

export interface LoginAck {
  type: MessageType.LOGIN_ACK;
  result: LoginResult;
  username?: string;
  mapX?: number;
  mapY?: number;
  playerId?: number;
  clothing?: string;
  mapId?: number;
  HP?: number;
  MP?: number;
}

export interface MoveReq {
  type: MessageType.MOVE_REQ;
  mapX: number;
  mapY: number;
}

export interface MoveAck {
  type: MessageType.MOVE_ACK;
  result: MoveResult;
}

export interface MoveNtf {
  type: MessageType.MOVE_NTF;
  playerId: number;
  mapX: number;
  mapY: number;
}

export interface AddPlayer {
  playerId: number;
  mapX: number;
  mapY: number;
  username: string;
  clothing: string;
  HP: number;
  MP: number;
}

export interface AddPlayerNtf {
  type: MessageType.ADD_PLAYER_NTF;
  addPlayer: AddPlayer[];
}

export interface RemovePlayerNtf {
  type: MessageType.REMOVE_PLAYER_NTF;
  playerId: number;
}

export interface CastSkillReq {
  type: MessageType.CAST_SKILL_REQ;
  skillId: number;
  attackType: AttackType;
  targetId?: number;
  mapX?: number;
  mapY?: number;
}

export interface CastSkillAck {
  type: MessageType.CAST_SKILL_ACK;
  result: CastSkillResult;
}

export interface SkillHarm {
  type: ObjectType;
  targetId: number;
  harmValue: number;
}

export interface CastSkillNtf {
  type: MessageType.CAST_SKILL_NTF;
  playerId: number;
  skillId: number;
  attackType: AttackType;
  targetId?: number;
  mapX?: number;
  mapY?: number;
  skillHarms?: SkillHarm[];
}

export interface HPUpdateNtf {
  type: MessageType.HP_UPDATE_NTF;
  playerId: number;
  HP: number;
}

export interface MPUpdateNtf {
  type: MessageType.MP_UPDATE_NTF;
  playerId: number;
  MP: number;
}

export interface AddMonster {
  monsterId: number;
  mapX: number;
  mapY: number;
  typeId: number;
  HP: number;
}

export interface AddMonsterNtf {
  type: MessageType.ADD_MONSTER_NTF;
  addMonster: AddMonster[];
}

export interface ChatReq {
  type: MessageType.CHAT_REQ;
  msg: string;
}

export interface ChatNtf {
  type: MessageType.CHAT_NTF;
  playerId: number;
  username: string;
  msg: string;
}

// Union type for all messages
export type GameMessage =
  | LoginReq
  | LoginAck
  | MoveReq
  | MoveAck
  | MoveNtf
  | AddPlayerNtf
  | RemovePlayerNtf
  | CastSkillReq
  | CastSkillAck
  | CastSkillNtf
  | HPUpdateNtf
  | MPUpdateNtf
  | AddMonsterNtf
  | ChatReq
  | ChatNtf;

// Message serialization helpers
export class Protocol {
  static serialize(message: GameMessage): string {
    return JSON.stringify(message);
  }

  static deserialize(data: string): GameMessage {
    return JSON.parse(data) as GameMessage;
  }
}

