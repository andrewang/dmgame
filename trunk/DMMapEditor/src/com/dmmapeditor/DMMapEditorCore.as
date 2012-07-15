package com.dmmapeditor
{
	import com.dmgame.asset.AssetShell;
	import com.dmgame.asset.BaseMapConfigShell;
	import com.dmgame.asset.BaseMapEntryShell;
	import com.dmgame.asset.BaseMapGridDataShell;
	import com.dmgame.asset.MapJumpPointEntryShell;
	import com.dmgame.asset.MapKeyPointEntryShell;
	import com.dmgame.dmlogic.asset.MapJumpPointEntry;
	import com.dmgame.dmlogic.asset.MapKeyPointEntry;
	import com.dmgame.dmlogic.astar.AstarWall;
	import com.dmgame.dmlogic.grid.MapGridData;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class DMMapEditorCore
	{
		public var url_:String; // 资源路径
		
		public var gridWidth_:int; // 默认给子宽
		
		public var gridHeight_:int; // 默认格子高
		
		public var tileWidth_:int; // 默认切片宽
		
		public var tileHeight_:int; // 默认切片高
		
		public static var singleton_:DMMapEditorCore; // 单件
		
		protected var isInited_:Boolean = false; // 是否已经初始化过 
		
		protected var onInited_:Function; // 初始化回调函数
		
		public var mapAsset_:AssetShell; // 地图配置
		
		public var nextMapID_:int; // 新建地图的编号
		
		public var currentMapID_:int; // 当前在操作的地图编号
		
		public var currentPosx_:int; // 当前x坐标
		
		public var currentPosy_:int; // 当前y坐标
		
		public var mapConfig_:BaseMapConfigShell; // 地表切片配置
		
		public var mapAssetEntry_:BaseMapEntryShell; // 地图资源条目
		
		public var blockGridData_:BaseMapGridDataShell; // 障碍数组
		
		public var shadowGridData_:BaseMapGridDataShell; // 阴影数组
		
		public var jumpPointAsset_:AssetShell; // 跳转点配置
		
		public var nextJumpPointID_:int; // 下一个跳转点的编号
		
		public var keyPointAsset_:AssetShell; // 关键点配置
		
		public var nextKeyPointID_:int; // 下一个关键点的编号
		
		public var astarWall_:AstarWall; // A星测试
		
		public function DMMapEditorCore()
		{
			singleton_ = this;
			
			// 地图资源
			mapAsset_ = new AssetShell(BaseMapEntryShell.CreateEntry);
		}
		
		public function Init(onInited:Function):void
		{
			if(isInited_) {
				return;
			}
			isInited_ = true;
			
			// 读取环境配置
			var editorXmlLoader:URLLoader = new URLLoader;
			editorXmlLoader.addEventListener(Event.COMPLETE, onEditorXmlLoadComplete);
			editorXmlLoader.load(new URLRequest('assets/config/editor.xml'));
			
			// 回调函数
			onInited_ = onInited;
		}
		
		protected function onEditorXmlLoadComplete(event:Event):void
		{
			// 加载地图列表，如果没有，可以生成一份新的
			var editorXml:XML = new XML(event.target.data);
			var editorXmlList:XMLList = editorXml.child("url");
			if(editorXmlList.length() > 0) {
				url_ = editorXmlList[0].text();
			}
			
			editorXmlList = editorXml.child("gridWidth");
			if(editorXmlList.length() > 0) {
				gridWidth_ = editorXmlList[0].text();
			}
			
			editorXmlList = editorXml.child("gridHeight");
			if(editorXmlList.length() > 0) {
				gridHeight_ = editorXmlList[0].text();
			}
			
			editorXmlList = editorXml.child("tileWidth");
			if(editorXmlList.length() > 0) {
				tileWidth_ = editorXmlList[0].text();
			}
			
			editorXmlList = editorXml.child("tileHeight");
			if(editorXmlList.length() > 0) {
				tileHeight_ = editorXmlList[0].text();
			}
			
			
			// 加载地图列表
			mapAsset_.load(url_+'assets/map/base_map_list.xml', onMapListLoadComplete);
		}
		
		protected function onMapListLoadComplete():void
		{
			// 获取最大的编号
			var maxMapID:int;
			for(var mapID:* in mapAsset_.entries_)
			{
				maxMapID = Math.max(mapID as int, maxMapID);
			}
			nextMapID_ = maxMapID+1;
			
			// 回调函数
			if(onInited_ != null) {
				onInited_();
				onInited_ = null;
			}
		}
		
		public function addMap(mapID:int):void
		{
			nextMapID_ = Math.max(mapID+1, nextMapID_);
		}
		
		public function loadMap(mapID:int):void
		{
			currentMapID_ = mapID;
			
			mapAssetEntry_ = DMMapEditorCore.singleton_.mapAsset_.entries_[mapID];
			
			// 加载具体配置
			mapConfig_ = new BaseMapConfigShell;
			mapConfig_.load(url_+'assets/map/'+mapAssetEntry_.id_+'/config.xml', onMapTileAssetLoadComplete);
		}
		
		public function saveMap():void
		{
			// 保存具体配置
			if(mapConfig_) {
				mapConfig_.save(url_+'assets/map/'+mapAssetEntry_.id_+'/config.xml');
			}
			
			// 保存菱形格
			if(blockGridData_) {
				blockGridData_.save(url_+'assets/map/'+mapAssetEntry_.id_+'/block.dat');
			}
			if(shadowGridData_) {
				shadowGridData_.save(url_+'assets/map/'+mapAssetEntry_.id_+'/c_shadow.dat');
			}
			
			// 保存跳转点配置
			if(jumpPointAsset_) {
				jumpPointAsset_.save(url_+'assets/map/'+mapAssetEntry_.id_+'/jump_point.xml');
			}
			
			// 保存关键点配置
			if(keyPointAsset_) {
				keyPointAsset_.save(url_+'assets/map/'+mapAssetEntry_.id_+'/s_key_point.xml');
			}
		}
		
		protected function onMapTileAssetLoadComplete():void
		{
			// 计算
			var gridWCount:int = (mapConfig_.mapWidth_ + gridWidth_ - 1) / gridWidth_;
			var gridHCount:int = (mapConfig_.mapHeight_ + gridHeight_ - 1) / gridHeight_ * 2 - 1;
			
			// 同步加载障碍和阴影
			blockGridData_ = new BaseMapGridDataShell();
			if(!blockGridData_.load(url_+'assets/map/'+mapAssetEntry_.id_+'/block.dat')) {
				blockGridData_.create(gridHCount, gridWCount, gridWidth_, gridHeight_);
			}
			
			shadowGridData_ = new BaseMapGridDataShell();
			if(!shadowGridData_.load(url_+'assets/map/'+mapAssetEntry_.id_+'/c_shadow.dat')) {
				shadowGridData_.create(gridHCount, gridWCount, gridWidth_, gridHeight_);
			}
			
			// A星数据
			astarWall_ = new AstarWall(blockGridData_);
			
			// 加载跳转点配置
			jumpPointAsset_ = new AssetShell(MapJumpPointEntryShell.CreateEntry);
			jumpPointAsset_.load(url_+'assets/map/'+mapAssetEntry_.id_+'/jump_point.xml', onMapJumpPointAssetLoadComplete);
		}
		
		protected function onMapJumpPointAssetLoadComplete():void
		{
			for each(var entry:MapJumpPointEntry in this.jumpPointAsset_.entries_)
			{
				nextJumpPointID_ = Math.max(entry.id_+1, nextJumpPointID_);
			}
			
			
			// 加载关键点配置
			keyPointAsset_ = new AssetShell(MapKeyPointEntryShell.CreateEntry);
			keyPointAsset_.load(url_+'assets/map/'+mapAssetEntry_.id_+'/s_key_point.xml', onMapKeyPointAssetLoadComplete);
		}
		
		protected function onMapKeyPointAssetLoadComplete():void
		{
			for each(var entry:MapKeyPointEntry in this.keyPointAsset_.entries_)
			{
				nextKeyPointID_ = Math.max(entry.id_+1, nextKeyPointID_);
			}
			
			// 视窗同步
			DMMapView.singleton_.Init(mapAssetEntry_, mapConfig_, blockGridData_, shadowGridData_);
			DMSmallMapView.singleton_.Init(mapAssetEntry_, mapConfig_);
		}
		
		public function Update():void
		{
			DMMapView.singleton_.Update();
			DMSmallMapView.singleton_.Update();
		}
	}
}