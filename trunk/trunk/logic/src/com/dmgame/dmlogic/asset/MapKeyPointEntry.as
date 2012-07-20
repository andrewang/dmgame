package com.dmgame.dmlogic.asset
{
	import com.dmgame.xenon.asset.AssetEntry;
	
	public class MapKeyPointEntry extends AssetEntry
	{
		public var id_:int; // 编号
		
		public var posx_:int; // x坐标
		
		public var posy_:int; // y坐标
		
		public function MapKeyPointEntry()
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
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapKeyPointEntry;
		}
	}
}