package com.dmmapeditor
{
	import com.dmgame.asset.BaseMapConfigShell;
	import com.dmgame.asset.BaseMapEntryShell;
	import com.dmgame.asset.BaseMapGridDataShell;
	import com.dmgame.game.map.Tiles;
	import com.dmgame.logic.grid.MapGridData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.containers.Tile;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;

	public class DMMapView
	{
		public static var singleton_:DMMapView; // 单件
		
		protected var tile_:Tiles; // 地表
		
		public var grid_:DMMapGrid; // 格子
		
		protected var jumpPoint_:DMMapJumpPoint; // 跳转点
		
		protected var keyPoint_:DMMapKeyPoint; // 关键点
		
		protected var bitmapData_:BitmapData; // 位图
		
		protected var group_:Group; // 组
		
		protected var spriteElement:SpriteVisualElement = new SpriteVisualElement; // 精灵元素
		
		public function DMMapView(group:Group)
		{
			singleton_ = this;
			
			group_ = group;
			group_.clipAndEnableScrolling = true;
			
			// 提供一个bitmap的画板给我
			bitmapData_ = new BitmapData(group_.width, group_.height, false, 0);
			spriteElement.addChild(new Bitmap(bitmapData_));
			
			group_.addElement(spriteElement);
		}
		
		public function Init(mapAssetEntry:BaseMapEntryShell, mapTileAsset:BaseMapConfigShell, blockGridData:BaseMapGridDataShell, shadowGridData:BaseMapGridDataShell):void
		{
			// 初始化对象
			tile_ = new Tiles(DMMapEditorCore.singleton_.url_+'assets/tiles/'+mapAssetEntry.id_+'/', mapTileAsset);
			grid_ = new DMMapGrid(mapTileAsset, blockGridData, shadowGridData);
			jumpPoint_ = new DMMapJumpPoint(DMMapEditorCore.singleton_.jumpPointAsset_);
			keyPoint_ = new DMMapKeyPoint(DMMapEditorCore.singleton_.keyPointAsset_);
			
			// child方式
			spriteElement.addChild(grid_);
		}
		
		public function Update():void
		{
			// 刷新画面
			if(tile_ != null) {
				tile_.render(bitmapData_, DMMapEditorCore.singleton_.currentPosx_, DMMapEditorCore.singleton_.currentPosy_, group_.width, group_.height);
			}	
			if(grid_ != null) {
				grid_.x = -DMMapEditorCore.singleton_.currentPosx_;
				grid_.y = -DMMapEditorCore.singleton_.currentPosy_;
//				grid_.render(bitmapData_, DMMapEditorCore.singleton_.currentPosx_, DMMapEditorCore.singleton_.currentPosy_, group_.width, group_.height);
			}
			if(jumpPoint_ != null) {
				jumpPoint_.render(bitmapData_, DMMapEditorCore.singleton_.currentPosx_, DMMapEditorCore.singleton_.currentPosy_);
			}
			if(keyPoint_ != null) {
				keyPoint_.render(bitmapData_, DMMapEditorCore.singleton_.currentPosx_, DMMapEditorCore.singleton_.currentPosy_);
			}
		}
		
		public function width():int
		{
			return group_.width;
		}
		
		public function height():int
		{
			return group_.height;
		}
	}
}