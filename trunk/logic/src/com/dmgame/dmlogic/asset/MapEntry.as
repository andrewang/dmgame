package com.dmgame.dmlogic.asset
{
	import com.dmgame.xenon.asset.AssetEntry;

	public class MapEntry extends AssetEntry
	{
		public var id_:int; // 编号
		
		public var name_:String; // 地图名称
		
		public var isBattle_:Boolean; // 是否战斗地图
		
		public var invisibleMineScript_:String; // 不可见什么脚本
		
		public var initMapScript_:String; // 初始化地图脚本
		
		/**
		 * 构造函数
		 */
		public function MapEntry()
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
			
			xmlList = xml.child('Name');
			if(xmlList.length() > 0) {
				name_ = xmlList[0].text();
			}
			
			xmlList = xml.child('Battle');
			if(xmlList.length() > 0) {
				isBattle_ = (xmlList[0].text() == 'true');
			}
			
			xmlList = xml.child('InvisibleMineScript');
			if(xmlList.length() > 0) {
				invisibleMineScript_ = xmlList[0].text();
			}
			
			xmlList = xml.child('InitMapScript');
			if(xmlList.length() > 0) {
				initMapScript_ = xmlList[0].text();
			}
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapEntry;
		}
	}
}