package com.dmgame.logic.asset
{
	import com.dmgame.xenon.asset.AssetEntry;
	
	public class MapJumpPointEntry extends AssetEntry
	{
		public var id_:int; // 编号
		
		public var posx_:int; // x坐标
		
		public var posy_:int; // y坐标
		
		public var toMapID_:int; // 跳转目的地图
		
		public var toMapPosx_:int; // 跳转x坐标
		
		public var toMapPosy_:int; // 跳转y坐标
		
		public function MapJumpPointEntry()
		{
			super();
		}
		
		/**
		 * 条目索引
		 */
		override public function ID():*
		{
			return id_;
		}
		
		/**
		 * 读取条目
		 */
		override public function Load(xml:XML):Boolean
		{
			var xmlList:XMLList = xml.child('ID');
			if(xmlList.length() > 0) {
				id_ = xmlList[0].text();
			}
			
			xmlList = xml.child('Posx');
			if(xmlList.length() > 0) {
				posx_ = xmlList[0].text();
			}
			
			xmlList = xml.child('Posy');
			if(xmlList.length() > 0) {
				posy_ = xmlList[0].text();
			}
			
			xmlList = xml.child('ToMapID');
			if(xmlList.length() > 0) {
				toMapID_ = xmlList[0].text();
			}
			
			xmlList = xml.child('ToMapPosx');
			if(xmlList.length() > 0) {
				toMapPosx_ = xmlList[0].text();
			}
			
			xmlList = xml.child('ToMapPosy');
			if(xmlList.length() > 0) {
				toMapPosy_ = xmlList[0].text();
			}
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapJumpPointEntry;
		}
	}
}