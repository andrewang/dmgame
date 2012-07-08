package com.dmgame.entity
{
	public class MapEntityState
	{
		protected var mapEntity_:MapEntity; // 状态机拥有者实体
		
		public function MapEntityState(mapEntity:MapEntity)
		{
			mapEntity_ = mapEntity;
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return '';
		}
		
		/**
		 * 进入
		 */
		public function enter():void
		{
			
		}
		
		/**
		 * 离开
		 */
		public function leave():void
		{
			
		}
		
		/**
		 * 更新
		 */
		public function update():Boolean
		{
			return false;
		}
	}
}