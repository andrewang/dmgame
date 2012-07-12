package com.dmgame.game.map
{
	import com.dmgame.logic.entity.Entity;
	import com.dmgame.game.entity.GameEntity;
	import com.dmgame.logic.entity.MapEntity;
	import com.dmgame.game.object.EntityObject;
	import com.dmgame.game.object.RenderObject;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import com.dmgame.logic.map.Map;

	/**
	 * 游戏地图，带绘制功能
	 */
	public class GameMap extends Map
	{
		protected var renderObjects_:Array = []; // 绘制对象列表
		
		protected var tiles_:Tiles; // 地表
		
		/**
		 * 构造函数
		 */
		public function GameMap()
		{
		}
		
		/**
		 * 核心资源加载完毕
		 */
		override protected function onMapConfigLoadComplete():void
		{
			super.onMapConfigLoadComplete();
			
			// 初始化地表
			tiles_ = new Tiles('assets/tiles/'+mapId_+'/', mapConfig_);
		}
		
		/**
		 * 添加实体进入地图
		 */
		override public function addEntity(entity:MapEntity):void
		{
			if(entity is GameEntity) {
				
				var gameEntity:GameEntity = entity as GameEntity;
				
				super.addEntity(gameEntity);
				
				// 添加实体物件进入绘制队列
				var entityObject:EntityObject = new EntityObject;
				entityObject.entity = gameEntity;
				renderObjects_.push(entityObject);
			}
		}
		
		/**
		 * 绘制
		 */
		public function render(screenBitmapData:BitmapData, pos:Point):void
		{
			// 脏矩形计算，坐标移动与帧图像变更都是脏矩形
			
			// 排序
			renderObjects_.sortOn('zOrder', Array.NUMERIC);
			
			// 绘制地表
			if(tiles_ != null) {
				tiles_.render(screenBitmapData, pos.x, pos.y, screenBitmapData.width, screenBitmapData.height);
			}
			
			// 绘制物件
			for each(var renderObject:RenderObject in renderObjects_)
			{
				renderObject.render(screenBitmapData, pos);
			}
		}
	}
}