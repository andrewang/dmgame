package com.dmgame.dmlogic.entity
{
	import com.dmgame.dmlogic.map.Map;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * 地图实体，具有距离，行动概念
	 */
	public class MapEntity extends Entity
	{
		protected var map_:Map; // 当前所在地图
		
		protected var pos_:Point = new Point(0,0); // 地图坐标
		
		public var stateGroup_:MapEntityStateGroup; // 状态机组
		
		public function MapEntity()
		{
			stateGroup_ = new MapEntityStateGroup(this);
		}
		
		/**
		 * 更新地图实体
		 */
		override public function update(currentTime:int):void
		{
			super.update(currentTime);
			stateGroup_.update();
		}
		
		/**
		 * 设置所在地图
		 */
		public function set map(value:Map):void
		{
			map_ = value;
		}
		
		public function get map():Map
		{
			return map_;
		}
		
		/**
		 * 获取实体坐标
		 */
		public function set pos(value:Point):void
		{
			pos_.copyFrom(value);
		}
		
		public function get pos():Point
		{
			return pos_;
		}
	}
}