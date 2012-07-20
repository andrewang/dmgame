package com.dmgame.dmlogic.grid
{
	public class MapGridData
	{
		protected var gridHCount_:uint; // 行数
		
		protected var gridWCount_:uint; // 列数
		
		protected var gridWidth_:uint; // 宽
		
		protected var gridHeight_:uint; // 高
		
		protected var grids_:Array; // 格子数组
		
		public function MapGridData()
		{
		}
		
		public function create(gridHCount:uint, gridWCount:uint, gridWidth:uint, gridHeight:uint):void
		{
			gridHCount_ = gridHCount;
			gridWCount_ = gridWCount;
			gridWidth_ = gridWidth;
			gridHeight_ = gridHeight;
			
			grids_ = new Array;
			for(var i:int=0; i<gridHCount_; ++i)
			{
				grids_[i] = new Array;
			}
		}
		
		public function get gridHCount():uint
		{
			return gridHCount_;
		}
		
		public function get gridWCount():uint
		{
			return gridWCount_;
		}
		
		public function get gridWidth():uint
		{
			return gridWidth_;
		}
		
		public function get gridHeight():uint
		{
			return gridHeight_;
		}
		
		/**
		 * 获取格子
		 */
		public function getGrid(x:int, y:int):Boolean
		{
			if(x < 0 || y < 0 || x >= gridWCount_ || y >= gridHCount_) {
				return true;
			}
			return grids_[y][x];
		}
		
		/**
		 * 设置格子
		 */
		public function setGrid(x:int, y:int, s:Boolean):void
		{
			grids_[y][x] = s;
		}
	}
}