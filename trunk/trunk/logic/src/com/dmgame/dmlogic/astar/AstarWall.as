package com.dmgame.dmlogic.astar
{
	import com.dmgame.dmlogic.grid.MapGridData;
	
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class AstarWall extends AStarGridBase
	{
		protected var data_:MapGridData; // 地图块数据
		
		public function AstarWall(data:MapGridData)
		{
			data_ = data;
		}
		
		public override function isWalk(x:int, y:int):Boolean
		{
			return !data_.getGrid(x, y);
		}
		
		public override function getWalkable(x:int, y:int):Boolean
		{
			return !data_.getGrid(x, y);
		}
		
		public override function get numCols():int
		{
			return data_.gridWCount;
		}
		
		public override function get numRows():int
		{
			return data_.gridHCount;
		}
		
		public override function get nodeWidth():int
		{
			return data_.gridWidth;
		}
		
		public override function get nodeHeight():int
		{
			return data_.gridHeight;
		}
	}
}