package com.dmgame.asset
{
	import com.dmgame.logic.asset.MapJumpPointEntry;
	import com.dmgame.xenon.asset.AssetEntry;
	
	public class MapJumpPointEntryShell extends MapJumpPointEntry
	{
		public function MapJumpPointEntryShell()
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
			
			childXml = <ToMapID>{toMapID_}</ToMapID>;
			xml.appendChild(childXml);
			
			childXml = <ToMapPosx>{toMapPosx_}</ToMapPosx>;
			xml.appendChild(childXml);
			
			childXml = <ToMapPosy>{toMapPosy_}</ToMapPosy>;
			xml.appendChild(childXml);
			
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new MapJumpPointEntryShell;
		}
	}
}