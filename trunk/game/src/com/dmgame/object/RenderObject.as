package com.dmgame.object
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 绘图对象，可能包括实体，场景物件等
	 */
	public class RenderObject
	{
		/**
		 * 构造函数
		 */
		public function RenderObject()
		{
		}
		
		/**
		 * 排序参考
		 */
		public function get zOrder():int
		{
			return 0;
		}
		
		/**
		 * 绘制
		 */
		public function render(screen:BitmapData, pos:Point):void
		{
			
		}
	}
}