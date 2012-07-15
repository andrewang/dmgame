package com.dmgame.asset
{
	import com.dmgame.dmlogic.asset.MapKeyPointEntry;
	import com.dmgame.xenon.asset.AssetEntry;
	
	public class MapKeyPointEntryShell extends MapKeyPointEntry
	{
		public function MapKeyPointEntryShell()
		{
			super();
		}
		
		/**
		 * 保存条目
		 */
		override public function Save(xml:XML):Boolean
		{
			var childXml:XML = <ID>{id_}</ID>;
			xml.appendChild(childXml);
			
			childXml = <Posx>{posx_}</Posx>;
			xml.appendChild(childXml);
			
			childXml = <Posy>{posy_}</Posy>;
			xml.appendChild(childXml);
			
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapKeyPointEntryShell;
		}
	}
}