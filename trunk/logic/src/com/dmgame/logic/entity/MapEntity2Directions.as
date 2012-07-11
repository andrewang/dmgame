package com.dmgame.logic.entity
{
	import flash.geom.Point;
	
	public class MapEntity2Directions implements MapEntityDirections
	{
		public function MapEntity2Directions()
		{
		}
		
		/**
		 * 根据角度值获取角色的方向
		 */ 
		public function getDirectionWhenMove(moveStartPos:Point, moveEndPos:Point, defaultEntityDirection:int):int
		{
			if(moveEndPos.x > moveStartPos.x) {
				return EntityDirections.right;
			}
			else if(moveEndPos.x < moveStartPos.x) {
				return EntityDirections.left;
			}
			else {
				return defaultEntityDirection;
			}
		}
		
		/**
		 * 获取正确的方向
		 */
		public function getDirection(direction:int, defaultEntityDirection:int):int
		{
			switch(direction)
			{
				case EntityDirections.left:
					return EntityDirections.left;
				case EntityDirections.leftUp:
					return EntityDirections.left;
				case EntityDirections.leftDown:
					return EntityDirections.left;
				case EntityDirections.right:
					return EntityDirections.right;
				case EntityDirections.rightUp:
					return EntityDirections.right;
				case EntityDirections.rightDown:
					return EntityDirections.right;
			}
			return defaultEntityDirection;
		}
	}
}