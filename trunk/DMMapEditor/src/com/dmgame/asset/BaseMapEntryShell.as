package com.dmgame.asset
{
	import com.dmgame.logic.asset.MapEntry;
	import com.dmgame.xenon.asset.AssetEntry;

	public class BaseMapEntryShell extends AssetEntry
	{
		public var id_:int; // 编号
		
		public var name_:String; // 地图名称
		
		public function BaseMapEntryShell()
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
			
			return true;
		}
		
		/**
		 * 保存条目
		 */
		override public function Save(xml:XML):Boolean
		{
			var childXml:XML = <ID>{id_}</ID>;
			xml.appendChild(childXml);
			
			childXml = <Name>{name_}</Name>;
			xml.appendChild(childXml);

			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new BaseMapEntryShell;
		}
	}
}