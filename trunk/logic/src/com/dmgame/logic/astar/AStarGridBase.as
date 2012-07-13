package com.dmgame.logic.astar
{
	public class AStarGridBase
	{
		public function AStarGridBase()
		{
		}
		
		public function notIsBorder(a:int, b:int):Boolean
		{
			if(a < 0 || b < 0){
				return false;
			}
			if(a >= numCols){
				return false;
			}
			if(b >= numRows){
				return false;
			}
			return true;
		}
		
		public function getNode(x:int, y:int):*
		{
			return null;
		}
		
		public function isWalk(x:int, y:int):Boolean
		{
			return false;
		}
		
		public function getWalkable(x:int, y:int):Boolean
		{
			return false;
		}
		
		public function get numCols():int
		{
			return 0;
		}
		
		public function get numRows():int
		{
			return 0;
		}
		
		public function get nodeWidth():int
		{
			return 0;
		}
		
		public function get nodeHeight():int
		{
			return 0;
		}
	}
}