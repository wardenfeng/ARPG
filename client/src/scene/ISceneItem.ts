export interface ISceneItem {
  getFloorX(): number;
  getFloorY(): number;
  update?(deltaTime: number): void;
}

