package com.dmgame.map
{
	import com.dmgame.asset.Assets;
	import com.dmgame.asset.MapAssetEntry;
	import com.dmgame.asset.MapGridAsset;
	import com.dmgame.entity.Entity;
	import com.dmgame.entity.MapEntity;
	import com.dmgame.entity.MapEntity2Directions;
	import com.dmgame.entity.MapEntity8Directions;
	import com.dmgame.entity.MapEntityDirections;
	
	/**
	 * 地图
	 */
	public class Map
	{
		public var mapId_:int; // 地图编号
		
		public var width_:int; // 地图宽
		
		public var height_:int; // 地图高
		
		public var entities_:Array = []; // 实体列表
		
		public var mapAssetEntry_:MapAssetEntry; // 地图配置条目
		
		public var mapGridAsset_:MapGridAsset; // 地表配置
		
		public var currentTime_:int; // 地图当前时间
		
		public var mapEntityDirectionsCurrent_:MapEntityDirections; // 实体方向接口
		
		public static var mapEntity8Directions_:MapEntity8Directions = new MapEntity8Directions; // 实体8方向
		
		public static var mapEntity2Directions_:MapEntity2Directions = new MapEntity2Directions; // 实体2方向
		
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
			var mapAssetEntry:MapAssetEntry = Assets.singleton_.mapAsset_.entries_[id] as MapAssetEntry;
			if(mapAssetEntry == null) {
				return false;
			}
			var mapGridAsset:MapGridAsset = Assets.singleton_.mapGridAsset_[mapAssetEntry.config_] as MapGridAsset;
			if(mapGridAsset == null) {
				return false;
			}
			
			mapAssetEntry_ = mapAssetEntry;
			mapGridAsset_ = mapGridAsset;
			
			if(mapAssetEntry_.isBattle_) {
				mapEntityDirectionsCurrent_ = mapEntity2Directions_;
			}
			else {
				mapEntityDirectionsCurrent_ = mapEntity8Directions_;
			}
			
			width_ = mapGridAsset_.mapWidth_;
			height_ = mapGridAsset_.mapHeight_;
			
			return true;
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