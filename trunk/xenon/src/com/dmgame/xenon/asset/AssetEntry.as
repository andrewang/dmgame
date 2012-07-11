package com.dmgame.xenon.asset
{
	/**
	 * 资源条目模板
	 */
	public class AssetEntry
	{
		/**
		 * 构造函数
		 */
		public function AssetEntry()
		{
		}
		
		/**
		 * 条目索引
		 */
		public function ID():*
		{
			return null;
		}
		
		/**
		 * 读取条目
		 */
		public function Load(xml:XML):Boolean
		{
			return false;
		}
		
		/**
		 * 保存条目
		 */
		public function Save(xml:XML):Boolean
		{
			return false;
		}
	}
}