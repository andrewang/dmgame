package com.dmgame.map
{
	import com.dmgame.game.DMGame;
	import com.dmgame.sprite.DMSprite;
	import com.dmgame.sprite.DMSpritePool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class Tiles
	{
		protected var tilesFolder_:String;
		
		protected var width_:int;
		
		protected var height_:int;
		
		protected var tileWidth_:int;
		
		protected var tileHeight_:int;
		
		protected var tileFormat_:String;
		
		protected var sTilesFile_:String;
		
		protected var lastRenderTile_:Array = []; // 上次绘制地表
		
		protected var tileWCount_:int; // 切片横向数量
		
		protected var tileHCount_:int; // 切片纵向数量
		
		/**
		 * 构造函数，地表所在目录，地表宽高，切片宽高，缩略图文件
		 */
		public function Tiles(tilesFolder:String, width:int, height:int, tileWidth:int, tileHeight:int, tileFormat:String, sTilesFile:String)
		{
			tilesFolder_ = tilesFolder;
			width_ = width;
			height_ = height;
			tileWidth_ = tileWidth;
			tileHeight_ = tileHeight;
			tileFormat_ = tileFormat;
			sTilesFile_ = sTilesFile;
			
			tileWCount_ = width/tileWidth;
			tileHCount_ = height/tileHeight;
		}
		
		/**
		 * 绘制
		 */
		public function render(screenBitmapData:BitmapData, pos:Point):void
		{
			var sTilePosx:int = (pos.x - tileWidth_) / tileWidth_;
			var sTilePosy:int = (pos.y - tileHeight_) / tileHeight_;
			
			if(sTilePosx < 0) {
				sTilePosx = 0;
			}
			if(sTilePosy < 0) {
				sTilePosy = 0;
			}
			
			var eTilePosx:int = (pos.x + DMGame.singleton_.stage_.stageWidth + tileWidth_) / tileWidth_;
			var eTilePosy:int = (pos.y + DMGame.singleton_.stage_.stageHeight + tileHeight_) / tileHeight_;
			
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
						tileSprite = DMSpritePool.singleton_.createSprite(tilesFolder_+j+'_'+i+'.'+tileFormat_);
					}
					tileSprite.render(0, 0, screenBitmapData, new Point(i*tileWidth_-pos.x, j*tileHeight_-pos.y));
					
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