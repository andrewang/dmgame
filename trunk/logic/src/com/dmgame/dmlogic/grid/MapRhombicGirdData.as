package com.dmgame.dmlogic.grid
{
	import com.dmgame.dmlogic.utils.Rhombic;
	
	import flash.geom.Point;

	public class MapRhombicGirdData extends MapGridData
	{
		public function MapRhombicGirdData()
		{
			super();
		}
		
		/**
		 * 获取格子
		 */
		public function getGridByPixel(pixelX:int, pixelY:int):Boolean
		{
			var point:Point = Rhombic.pixelTransferCoordinateInRhombic(pixelX, pixelY, gridWidth_, gridHeight_);
			return getGrid(point.x, point.y);
		}
	}
}