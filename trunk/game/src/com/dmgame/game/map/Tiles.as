package com.dmgame.game.map
{
	import com.dmgame.logic.asset.MapConfig;
	import com.dmgame.xenon.sprite.DMSprite;
	import com.dmgame.xenon.sprite.DMSpritePool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Tiles
	{
		protected var tilesFolder_:String; // 文件夹
		
		protected var mapTileAsset_:MapConfig; // 地表配置
		
		protected var lastRenderTile_:Array = []; // 上次绘制地表
		
		protected var tileWCount_:int; // 切片横向数量
		
		protected var tileHCount_:int; // 切片纵向数量
		
		/**
		 * 构造函数，地表所在目录，地表宽高，切片宽高，缩略图文件
		 */
		public function Tiles(tilesFolder:String, mapTileAsset:MapConfig)
		{
			tilesFolder_ = tilesFolder;
			mapTileAsset_ = mapTileAsset;
			
			tileWCount_ = (mapTileAsset_.mapWidth_ + mapTileAsset_.tileWidth_ - 1)/mapTileAsset_.tileWidth_;
			tileHCount_ = (mapTileAsset_.mapHeight_ + mapTileAsset_.tileHeight_ - 1)/mapTileAsset_.tileHeight_;
		}
		
		/**
		 * 绘制
		 */
		public function render(screenBitmapData:BitmapData, posx:int, posy:int, width:int, height:int):void
		{
			var sTilePosx:int = (posx - mapTileAsset_.tileWidth_) / mapTileAsset_.tileWidth_;
			var sTilePosy:int = (posy - mapTileAsset_.tileHeight_) / mapTileAsset_.tileHeight_;
			
			if(sTilePosx < 0) {
				sTilePosx = 0;
			}
			if(sTilePosy < 0) {
				sTilePosy = 0;
			}
			
			var eTilePosx:int = (posx + width + mapTileAsset_.tileWidth_) / mapTileAsset_.tileWidth_;
			var eTilePosy:int = (posy + height + mapTileAsset_.tileHeight_) / mapTileAsset_.tileHeight_;
			
			if(eTilePosx >= tileWCount_) {
				eTilePosx = tileWCount_ - 1;
			}
			if(eTilePosy >= tileHCount_) {
				eTilePosy = tileHCount_ - 1;
			}
			
			// 从之前的列表中获取已加载的图片
			var currentRenderTile:Array = [];
			for(var i:int=sTilePosx; i<=eTilePosx; ++i)
			{
				for(var j:int=sTilePosy; j<=eTilePosy; ++j)
				{
					var tileSprite:DMSprite = lastRenderTile_[j+'_'+i];
					delete lastRenderTile_[j+'_'+i];
					
					if(tileSprite == null) {
						// 新的图片，需要加载
						tileSprite = DMSpritePool.singleton_.createSprite(tilesFolder_+j+'_'+i+'.'+mapTileAsset_.tileFormat_);
					}
					tileSprite.render(0, 0, screenBitmapData, new Point(i*mapTileAsset_.tileWidth_-posx, j*mapTileAsset_.tileHeight_-posy));
					
					currentRenderTile[j+'_'+i] = tileSprite;
				}
			}
			
			for each(var renderTile:DMSprite in lastRenderTile_)
			{
				DMSpritePool.singleton_.freeSprite(renderTile.file);
			}
			
			lastRenderTile_ = currentRenderTile;
		}
	}
}