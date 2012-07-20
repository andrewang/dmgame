package com.dmgame.dmlogic.entity
{
	public class MapEntityStateStandBy extends MapEntityState
	{
		public function MapEntityStateStandBy(mapEntity:MapEntity)
		{
			super(mapEntity);
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'standby';
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			// 站立下来
			mapEntity_.setAction('待机', true);
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
			return false;
		}
	}
}