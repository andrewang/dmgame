package com.dmgame.dmlogic.core
{
	import com.dmgame.dmlogic.asset.Assets;
	import com.dmgame.dmlogic.map.Map;

	/**
	 * 游戏逻辑核心
	 */
	public class Logic
	{
		protected var assets_:Assets = new Assets; // 必要配置
		
		protected var map_:Map; // 地图
		
		protected var createMapFunction_:Function; // 地图工厂函数
		
		/**
		 * 构造函数。传入地图工厂函数
		 */
		public function Logic(createMapFunction:Function)
		{
			map_ = createMapFunction();
		}
		
		/**
		 * 指定需要被激活的地图
		 */
		public function set mapID(value:int):void
		{
			map_.init(value);
		}
		
		/**
		 * 获取map对象
		 */
		public function get map():Map
		{
			return map_;
		}
		
		/**
		 * 更新
		 */
		public function update(currentTime:int):void
		{
			map_.update(currentTime);
		}
	}
}