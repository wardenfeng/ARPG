package modules.findpath
{
	import flash.utils.getTimer;

	/** A* 寻路算法 */
	public class AStar
	{
		//是否需要障碍物判断
		public var Isbalk : Boolean = false;

		//====================================
		//	Constants
		//====================================
		private const COST_HORIZONTAL : int = 10; //横向移动一格的路径评分

		private const COST_VERTICAL : int = 5; //竖向移动一格的路径评分

		private const COST_DIAGONAL : int = 11; //斜向移动一格的路径评分

		private const NOTE_ID : int = 0; //(单个)节点数组 节点ID 索引

		private const NOTE_OPEN : int = 1; //(单个)节点数组 是否在开启列表中 索引

		private const NOTE_CLOSED : int = 2; //(单个)节点数组 是否在关闭列表中 索引

		//====================================
		//	Member Variables
		//====================================
		// 开放列表 m_openList 是个二叉堆（一维数组），F值最小的节点始终排在最前。为加快排序，
		// 开放列表中只存放节点ID ，其它数据放在各自的一维数组中。
		private var m_mapTileModel : MapTileModel; //地图模型

		private var m_openList : Array; //开放列表，存放节点ID

		private var m_openCount : int; //开放列表长度

		private var m_openId : int; //节点加入开放列表时分配的唯一ID(从0开始) 根据此ID(从下面的列表中)存取节点数据

		// 这些数据列表都以节点ID为索引顺序存储。
		private var m_xList : Array; //节点x坐标列表

		private var m_yList : Array; //节点y坐标列表

		private var m_pathScoreList : Array; //节点路径评分列表

		private var m_movementCostList : Array; //(从起点移动到)节点的移动耗费列表

		private var m_fatherList : Array; //节点的父节点(ID)列表

		// 使用 m_noteMap 可以方便的存取任何位置节点的开启关闭状态，并可取其ID进而存取其它数据。m_noteMap 是个三维数组，
		// 第一维y坐标（第几行），第二维x坐标（第几列），第三维节点状态和ID。判断点(p_x, p_y)是否在开启列表中
		private var m_noteMap : Array; //节点(数组)地图,根据节点坐标记录节点开启关闭状态和ID

		private var m_maxTry : int; //最大寻延时,限制超时返回

		private var m_Start : int;

		private var m_End : int;

		//====================================
		//	Constructor
		//====================================
		/**
		 * Constructor
		 *
		 * @param p_mapTileModel	地图模型，实现 IMapTileModel 接口
		 * @param p_maxTry			最大寻路步数，限制超时返回
		 */
		public function AStar(p_mapTileModel : MapTileModel, p_maxTry : int = 600)
		{
			this.m_mapTileModel = p_mapTileModel;
			this.m_maxTry = p_maxTry;
		}

		//====================================
		//	Properties
		//====================================
		/**
		 * 最大寻路步数，限制超时返回
		 */
		public function get MaxTry() : int
		{
			return this.m_maxTry;
		}

		/**
		 * @private
		 */
		public function set MaxTry(p_value : int) : void
		{
			this.m_maxTry = p_value;
		}

		//====================================
		//	Public Methods
		//====================================
		/**
		 * 开始寻路
		 *
		 * @param p_startX		起点X坐标
		 * @param p_startY		起点Y坐标
		 * @param p_endX		终点X坐标
		 * @param p_endY		终点Y坐标
		 *
		 * @return 				找到的路径(二维数组 : [p_startX, p_startY], ... , [p_endX, p_endY])
		 */
		public function Find(p_startX : int, p_startY : int, p_endX : int, p_endY : int) : Array
		{
			this.m_Start = getTimer();

			this.InitLists(); // 初始化所有列表数组
			this.m_openCount = 0;
			this.m_openId = -1;

			this.OpenNote(p_startX, p_startY, 0, 0, 0); // 起点放到开启列表中

			var currTry : int = 0; // 寻路次数
			var currId : int;
			var currNoteX : int;
			var currNoteY : int;
			var aroundNotes : Array;

			var checkingId : int;

			var cost : int; // (从起点移动到)节点的移动耗费G值	
			var score : int; // 节点路径评分F值
			while (this.m_openCount > 0)
			{
				//超时返回
//				if (++currTry > this.m_maxTry)
//				{
//					this.DestroyLists();
//					return null;
//				}

				this.m_End = getTimer();
				if (this.m_End - this.m_Start > this.m_maxTry)
				{
					this.DestroyLists();
					return null;
				}
				//每次取出开放列表最前面的ID
				currId = this.m_openList[0];
				//将编码为此ID的元素列入关闭列表
				this.CloseNote(currId);
				currNoteX = this.m_xList[currId];
				currNoteY = this.m_yList[currId];

				//如果终点被放入关闭列表寻路结束，返回路径
				if (currNoteX == p_endX && currNoteY == p_endY)
				{
					return this.GetPath(p_startX, p_startY, currId);
				}
				//获取周围节点，排除不可通过和已在关闭列表中的
				aroundNotes = this.getArounds(currNoteX, currNoteY);
				//对于周围的每一个节点
				for each (var note : Array in aroundNotes)
				{
					//计算F和G值
					if (currNoteY == note[1]) // 横向－左右
					{
						cost = this.m_movementCostList[currId] + this.COST_HORIZONTAL;
					}
					else if (currNoteX == note[0]) // 竖向－上下
					{
						cost = this.m_movementCostList[currId] + this.COST_VERTICAL;
					}
					else // 斜向－左上 左下 右上 右下
					{
						cost = this.m_movementCostList[currId] + this.COST_DIAGONAL;
					}

					//X距离
					var xDistance : int = Math.abs(p_endX - note[0]) * COST_HORIZONTAL;
					//Y距离
					var yDistance : int = Math.abs(p_endY - note[1]) * COST_VERTICAL;
					// 90度地图估计开销F计算
					score = cost + Math.sqrt(xDistance * xDistance + yDistance * yDistance);

					if (this.IsOpen(note[0], note[1])) //如果节点已在播放列表中
					{
						checkingId = this.m_noteMap[note[1]][note[0]][NOTE_ID];
						//如果新的G值比节点原来的G值小,修改F,G值，换父节点
						if (cost < this.m_movementCostList[checkingId])
						{
							this.m_movementCostList[checkingId] = cost;
							this.m_pathScoreList[checkingId] = score;
							this.m_fatherList[checkingId] = currId;
							this.AheadNote(this.GetIndex(checkingId));
						}
					}
					else //如果节点不在开放列表中
					{
						//将节点放入开放列表
						this.OpenNote(note[0], note[1], score, cost, currId);
					}
				}
			}
			//开放列表已空，找不到路径
			this.DestroyLists();
			return null;
		}

		//====================================
		//	Private Methods
		//====================================
		/**
		 * @private
		 * 将节点加入开放列表
		 *
		 * @param p_x		节点在地图中的x坐标
		 * @param p_y		节点在地图中的y坐标
		 * @param P_score	节点的路径评分
		 * @param p_cost	起始点到节点的移动成本
		 * @param p_fatherId	父节点
		 */
		private function OpenNote(p_x : int, p_y : int, p_score : int, p_cost : int, p_fatherId : int) : void
		{
			this.m_openCount++;
			this.m_openId++;

			if (this.m_noteMap[p_y] == null)
			{
				this.m_noteMap[p_y] = [];
			}
			this.m_noteMap[p_y][p_x] = [];
			this.m_noteMap[p_y][p_x][NOTE_OPEN] = true;
			this.m_noteMap[p_y][p_x][NOTE_ID] = this.m_openId;

			this.m_xList.push(p_x);
			this.m_yList.push(p_y);
			this.m_pathScoreList.push(p_score);
			this.m_movementCostList.push(p_cost);
			this.m_fatherList.push(p_fatherId);

			this.m_openList.push(this.m_openId);
			this.AheadNote(this.m_openCount);
		}

		/**
		 * @private
		 * 将节点加入关闭列表
		 */
		private function CloseNote(p_id : int) : void
		{
			this.m_openCount--;
			var noteX : int = this.m_xList[p_id];
			var noteY : int = this.m_yList[p_id];
			this.m_noteMap[noteY][noteX][NOTE_OPEN] = false;
			this.m_noteMap[noteY][noteX][NOTE_CLOSED] = true;

			if (this.m_openCount <= 0)
			{
				this.m_openCount = 0;
				this.m_openList = [];
				return;
			}
			this.m_openList[0] = this.m_openList.pop();
			this.BackNote();
		}

		/**
		 * @private
		 * 将(新加入开放别表或修改了路径评分的)节点向前移动
		 */
		private function AheadNote(p_index : int) : void
		{
			var father : int;
			var change : int;
			while (p_index > 1)
			{
				//父节点的位置
				father = Math.floor(p_index / 2);
				//如果该节点的F值小于父节点的F值则和父节点交换
				if (this.GetScore(p_index) < this.GetScore(father))
				{
					change = this.m_openList[p_index - 1];
					this.m_openList[p_index - 1] = this.m_openList[father - 1];
					this.m_openList[father - 1] = change;
					p_index = father;
				}
				else
				{
					break;
				}
			}
		}

		/**
		 * @private
		 * 将(取出开启列表中路径评分最低的节点后从队尾移到最前的)节点向后移动
		 */
		private function BackNote() : void
		{
			//尾部的节点被移到最前面
			var checkIndex : int = 1;
			var tmp : int;
			var change : int;

			while (true)
			{
				tmp = checkIndex;
				//如果有子节点
				if (2 * tmp <= this.m_openCount)
				{
					//如果子节点的F值更小
					if (this.GetScore(checkIndex) > this.GetScore(2 * tmp))
					{
						//记节点的新位置为子节点位置
						checkIndex = 2 * tmp;
					}
					//如果有两个子节点
					if (2 * tmp + 1 <= this.m_openCount)
					{
						//如果第二个子节点F值更小
						if (this.GetScore(checkIndex) > this.GetScore(2 * tmp + 1))
						{
							//更新节点新位置为第二个子节点位置
							checkIndex = 2 * tmp + 1;
						}
					}
				}
				//如果节点位置没有更新结束排序
				if (tmp == checkIndex)
				{
					break;
				}
				//反之和新位置交换，继续和新位置的子节点比较F值
				else
				{
					change = this.m_openList[tmp - 1];
					this.m_openList[tmp - 1] = this.m_openList[checkIndex - 1];
					this.m_openList[checkIndex - 1] = change;
				}
			}
		}

		/**
		 * @private
		 * 判断某节点是否在开放列表
		 */
		private function IsOpen(p_x : int, p_y : int) : Boolean
		{
			if (this.m_noteMap[p_y] == null)
				return false;
			if (this.m_noteMap[p_y][p_x] == null)
				return false;
			return this.m_noteMap[p_y][p_x][NOTE_OPEN];
		}

		/**
		 * @private
		 * 判断某节点是否在关闭列表中
		 */
		private function IsClosed(p_x : int, p_y : int) : Boolean
		{
			if (this.m_noteMap[p_y] == null)
				return false;
			if (this.m_noteMap[p_y][p_x] == null)
				return false;
			return this.m_noteMap[p_y][p_x][NOTE_CLOSED];
		}

		/**
		 * @private
		 * 获取某节点的周围节点，排除不能通过和已在关闭列表中的
		 */
		private function getArounds(p_x : int, p_y : int) : Array
		{
			var arr : Array = [];
			var checkX : int;
			var checkY : int;

			//y&1 y是偶数是0，不属于红色方块某个，x左边-1.奇数是1 意思是，这个节点属于红色方块，说明x坐标不变

			//右下
//			checkX = p_x + (p_y & 1);
//			checkY = p_y + 1;
			checkX = p_x + 1;
			checkY = p_y;
			var canRightBottom : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canRightBottom && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//左下
//			checkX = p_x - 1 + (p_y & 1);
//			checkY = p_y + 1;
			checkX = p_x;
			checkY = p_y - 1;
			var canLeftBottom : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canLeftBottom && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//左上
//			checkX = p_x - 1 + (p_y & 1); 			
//			checkY = p_y - 1;
			checkX = p_x - 1;
			checkY = p_y;
			var canLeftTop : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canLeftTop && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//右上
//			checkX = p_x + (p_y & 1);
//			checkY = p_y - 1;
			checkX = p_x;
			checkY = p_y + 1;
			var canRightTop : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canRightTop && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//右
//			checkX = p_x + 1;
//			checkY = p_y;
			checkX = p_x + 1;
			checkY = p_y + 1;
			var canRight : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canRight && canRightTop && canRightBottom && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//下
//			checkX = p_x;
//			checkY = p_y + 2;
			checkX = p_x + 1;
			checkY = p_y - 1;
			var canDown : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canDown && canLeftBottom && canRightBottom && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//左
//			checkX = p_x - 1;
//			checkY = p_y;
			checkX = p_x - 1;
			checkY = p_y - 1;
			var canLeft : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canLeft && canLeftTop && canLeftBottom && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}
			//上
//			checkX = p_x;
//			checkY = p_y - 2;
			checkX = p_x - 1;
			checkY = p_y + 1;
			var canUp : Boolean = Isbalk || this.m_mapTileModel.IsBlock(p_x, p_y, checkX, checkY) != MapTileModel.PATH_BARRIER;
			if (canUp && canLeftTop && canRightTop && !this.IsClosed(checkX, checkY))
			{
				arr.push([checkX, checkY]);
			}

			return arr;
		}

		/**
		 * @private
		 * 获取路径
		 *
		 * @param p_startX	起始点X坐标
		 * @param p_startY	起始点Y坐标
		 * @param p_id		终点的ID
		 *
		 * @return 			路径坐标(Point)数组
		 */
		private function GetPath(p_startX : int, p_startY : int, p_id : int) : Array
		{
			var arr : Array = [];
			var noteX : int = this.m_xList[p_id];
			var noteY : int = this.m_yList[p_id];
			while (noteX != p_startX || noteY != p_startY)
			{
				arr.unshift([noteX, noteY]);
				p_id = this.m_fatherList[p_id];
				noteX = this.m_xList[p_id];
				noteY = this.m_yList[p_id];
			}
			arr.unshift([p_startX, p_startY]);
			this.DestroyLists();
			return arr;
		}

		/**
		 * @private
		 * 获取某ID节点在开放列表中的索引(从1开始)
		 */
		private function GetIndex(p_id : int) : int
		{
			var i : int = 1;
			for each (var id : int in this.m_openList)
			{
				if (id == p_id)
				{
					return i;
				}
				i++;
			}
			return -1;
		}

		/**
		 * @private
		 * 获取某节点的路径评分
		 *
		 * @param p_index	节点在开启列表中的索引(从1开始)
		 */
		private function GetScore(p_index : int) : int
		{
			return this.m_pathScoreList[this.m_openList[p_index - 1]];
		}

		/**
		 * @private
		 * 初始化数组
		 */
		private function InitLists() : void
		{
			this.m_openList = [];
			this.m_xList = [];
			this.m_yList = [];
			this.m_pathScoreList = [];
			this.m_movementCostList = [];
			this.m_fatherList = [];
			this.m_noteMap = [];
		}

		/**
		 * @private
		 * 销毁数组
		 */
		private function DestroyLists() : void
		{
			this.m_openList = null;
			this.m_xList = null;
			this.m_yList = null;
			this.m_pathScoreList = null;
			this.m_movementCostList = null;
			this.m_fatherList = null;
			this.m_noteMap = null;
		}
	}
}
