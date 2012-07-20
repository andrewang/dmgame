package com.dmgame.dmlogic.entity
{
	import com.dmgame.dmlogic.astar.AStarUtils;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class MapEntityStateMoveDirection extends MapEntityState
	{
		protected var direction_:int; // 移动方向
		
		protected var moveStartPos_:Point = new Point; // 移动起始点
		
		protected var moveStartTime_:int; // 移动起始时间
		
		public var moveSpeed_:int = 200; // 移动速度
		
		protected var k_:Number = Math.sin(Math.PI*45/180);
		
		public function MapEntityStateMoveDirection(mapEntity:MapEntity)
		{
			super(mapEntity);
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'move direction';
		}
		
		/**
		 * 初始化
		 */
		public function init(direction:int):void
		{
			// 设置移动相关变量
			direction_ = direction;
			moveStartPos_.copyFrom(mapEntity_.pos);
			moveStartTime_ = getTimer();
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			// 计算实体方向
			mapEntity_.direction = mapEntity_.map.mapEntityDirectionsCurrent_.getDirection(direction_, mapEntity_.direction);
		}
		
		/**
		 * 离开
		 */
		override public function leave():void
		{
		}
		
		/**
		 * 更新
		 */
		override public function update():Boolean
		{
			var currentTime:int = getTimer();
			
			var step:Number = (currentTime - moveStartTime_)/1000*moveSpeed_;
			
			var targetPos:Point = new Point(mapEntity_.pos.x, mapEntity_.pos.y);
			
			switch(direction_) 
			{
				case EntityDirections.up:
					targetPos.y = moveStartPos_.y - step;
					break;
				case EntityDirections.rightUp:
					targetPos.y = moveStartPos_.y - step*k_;
					targetPos.x = moveStartPos_.x + step*k_;
					break;
				case EntityDirections.right:
					targetPos.x = moveStartPos_.x + step;
					break;
				case EntityDirections.rightDown:
					targetPos.y = moveStartPos_.y + step*k_;
					targetPos.x = moveStartPos_.x + step*k_;
					break;
				case EntityDirections.down:
					targetPos.y = moveStartPos_.y + step;
					break;
				case EntityDirections.leftDown:
					targetPos.y = moveStartPos_.y + step*k_;
					targetPos.x = moveStartPos_.x - step*k_;
					break;
				case EntityDirections.left:
					targetPos.x = moveStartPos_.x - step;
					break;
				case EntityDirections.leftUp:
					targetPos.y = moveStartPos_.y - step*k_;
					targetPos.x = moveStartPos_.x - step*k_;
					break;
			}
			
			// 需要判断实体要去的点是否对头
			if(AStarUtils.linePathIsWalk(mapEntity_.pos.x, mapEntity_.pos.y, targetPos.x, targetPos.y, 1, mapEntity_.map.astarWall_)) {
				
				mapEntity_.pos.copyFrom(targetPos);
			}
			
			return false;
		}
	}
}