package com.dmgame.asset
{
	public class MapAssetEntry extends AssetEntry
	{
		public var id_:int; // 编号
		
		public var name_:String; // 地图名称
		
		public var config_:String; // 地图模板配置文件
		
		public var isBattle_:Boolean; // 是否战场地图
		
		/**
		 * 构造函数
		 */
		public function MapAssetEntry()
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
			
			xmlList = xml.child('Config');
			if(xmlList.length() > 0) {
				config_ = xmlList[0].text();
			}
			
			xmlList = xml.child('Name');
			if(xmlList.length() > 0) {
				name_ = xmlList[0].text();
			}
			
			xmlList = xml.child("Battle");
			if(xmlList.length() > 0) {
				isBattle_ = (xmlList[0].text() == 1);
			}
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapAssetEntry;
		}
	}
}