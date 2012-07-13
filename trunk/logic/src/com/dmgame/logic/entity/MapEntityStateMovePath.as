package com.dmgame.logic.entity
{
	public class MapEntityStateMovePath extends MapEntityState
	{
		protected var movePath_:Array; // 路径
		
		protected var movePathIndex_:int; // 路径索引
		
		protected var stateMoveTarget_:MapEntityStateMoveTarget; // 移动到目标点状态机
		
		public function MapEntityStateMovePath(mapEntity:MapEntity)
		{
			super(mapEntity);
			
			stateMoveTarget_ = new MapEntityStateMoveTarget(mapEntity);
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'move path';
		}
		
		/**
		 * 初始化
		 */
		public function init(movePath:Array):void
		{
			// 设置移动相关变量
			movePath_ = movePath;
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			movePathIndex_ = 0;
			stateMoveTarget_.init(movePath_[movePathIndex_]);
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
			if(stateMoveTarget_.update()) {
				
				
			}
			return true;
		}
	}
}