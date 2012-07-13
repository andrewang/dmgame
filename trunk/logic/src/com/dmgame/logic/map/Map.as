package com.dmgame.logic.map
{
	import com.dmgame.logic.asset.Assets;
	import com.dmgame.logic.asset.MapConfig;
	import com.dmgame.logic.asset.MapEntry;
	import com.dmgame.logic.astar.AstarWall;
	import com.dmgame.logic.entity.Entity;
	import com.dmgame.logic.entity.MapEntity;
	import com.dmgame.logic.entity.MapEntity2Directions;
	import com.dmgame.logic.entity.MapEntity8Directions;
	import com.dmgame.logic.entity.MapEntityDirections;
	import com.dmgame.logic.grid.MapGridData;
	import com.dmgame.logic.grid.MapGridDataParse;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * 地图
	 */
	public class Map
	{
		public var mapId_:int; // 地图编号
		
		public var width_:int; // 地图宽
		
		public var height_:int; // 地图高
		
		public var mapConfig_:MapConfig; // 地图配置
		
		public var astarWall_:AstarWall; // 寻路
		
		public var entities_:Array = []; // 实体列表
		
		public var mapAssetEntry_:MapEntry; // 地图配置条目
		
		public var currentTime_:int; // 地图当前时间
		
		public var mapEntityDirectionsCurrent_:MapEntityDirections; // 实体方向接口
		
		public static var mapEntity8Directions_:MapEntity8Directions = new MapEntity8Directions; // 实体8方向
		
		public static var mapEntity2Directions_:MapEntity2Directions = new MapEntity2Directions; // 实体2方向
		
		public var blockGridData_:MapGridData; // 格子配置
		
		public var shadowGridData_:MapGridData; // 格子配置
		
		/**
		 * 构造函数
		 */
		public function Map()
		{
		}
		
		/**
		 * 初始化地图
		 */
		public function init(id:int):Boolean
		{
			if(mapId_ == id) {
				return true;
			}
			
			mapId_ = id;
			
			// 清理实体
			for each(var entity:MapEntity in entities_)
			{
				entity.map = null;
			}
			entities_ = [];
			
			// 读取配置文件
			var mapAssetEntry:MapEntry = Assets.singleton_.mapAsset_.entries_[id] as MapEntry;
			if(mapAssetEntry == null) {
				return false;
			}
			mapAssetEntry_ = mapAssetEntry;
			
			// 加载具体配置
			mapConfig_ = new MapConfig;
			mapConfig_.load('assets/map/'+id+'/config.xml', onMapConfigLoadComplete);
			return true;
		}
		
		/**
		 * 地表配置加载完毕
		 */
		protected function onMapConfigLoadComplete():void
		{
			width_ = mapConfig_.mapWidth_;
			height_ = mapConfig_.mapHeight_;
			
			// 判断地图方向
			if(mapAssetEntry_.isBattle_) {
				mapEntityDirectionsCurrent_ = mapEntity2Directions_;
			}
			else {
				mapEntityDirectionsCurrent_ = mapEntity8Directions_;
			}
			
			// 同步加载障碍和阴影
			blockGridData_ = new MapGridData();
			shadowGridData_ = new MapGridData();
			
			var loader:URLLoader = new URLLoader(new URLRequest('assets/map/'+mapId_+'/block.dat'));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onMapBlockLoadComplete);
		}
		
		/**
		 * 障碍配置加载完毕
		 */
		protected function onMapBlockLoadComplete(event:Event):void
		{
			MapGridDataParse.parse(event.target.data, blockGridData_);
			event.target.removeEventListener(Event.COMPLETE, onMapBlockLoadComplete);
			
			astarWall_ = new AstarWall(blockGridData_);
			
			// 加载阴影
			event.target.load(new URLRequest('assets/map/'+mapId_+'/c_shadow.dat'));
			event.target.addEventListener(Event.COMPLETE, onMapShadowLoadComplete);
		}
		
		/**
		 * 阴影配置加载完毕
		 */
		protected function onMapShadowLoadComplete(event:Event):void
		{	
			MapGridDataParse.parse(event.target.data, shadowGridData_);
			event.target.removeEventListener(Event.COMPLETE, onMapShadowLoadComplete);
		}
		
		/**
		 * 添加实体进入地图
		 */
		public function addEntity(entity:MapEntity):void
		{
			if(entity != null) {
				
				entity.map = this;
				entities_.push(entity);
			}
		}
		
		/**
		 * 更新实体
		 */
		public function update(currentTime:int):void
		{
			currentTime_ = currentTime;
			
			for each(var entity:Entity in entities_)
			{
				entity.update(currentTime);
			}
		}
	}
}