package com.dmgame.dmlogic.entity
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class MapEntityStateMoveTarget extends MapEntityState
	{
		protected var moveStartPos_:Point = new Point(0,0); // 移动起始点
		
		protected var moveEndPos_:Point = new Point(0,0); // 移动目标点
		
		protected var moveStartTime_:int; // 更新时间
		
		protected var moveSpeed_:int = 200; // 移动速度
		
		public function MapEntityStateMoveTarget(mapEntity:MapEntity)
		{
			super(mapEntity);
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'move target';
		}
		
		/**
		 * 初始化
		 */
		public function init(moveEndPos:Point):void
		{
			// 设置移动相关变量
			moveStartPos_.copyFrom(mapEntity_.pos);
			moveEndPos_.copyFrom(moveEndPos);
			moveStartTime_ = getTimer();
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			// 计算实体方向
			mapEntity_.direction = mapEntity_.map.mapEntityDirectionsCurrent_.getDirectionWhenMove(moveStartPos_, moveEndPos_, mapEntity_.direction);
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
			
			if(moveEndPos_) {
				
				var d:Number = Point.distance(moveStartPos_, moveEndPos_);
				var step:Number = (currentTime - moveStartTime_)/1000*moveSpeed_;
				
				if((d != 0) && (d > step)) {
					
					var dx:int = moveEndPos_.x - moveStartPos_.x;
					var dy:int = moveEndPos_.y - moveStartPos_.y;
					
					mapEntity_.pos.x = moveStartPos_.x + dx/d*step;
					mapEntity_.pos.y = moveStartPos_.y + dy/d*step;
				}
				else {
					
					mapEntity_.pos = moveEndPos_;
					return true;
				}
			}
			return false;
		}
	}
}