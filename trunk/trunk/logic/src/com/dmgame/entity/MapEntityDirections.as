package com.dmgame.entity
{
	import flash.geom.Point;

	public interface MapEntityDirections
	{
		/**
		 * 根据角度值获取角色的方向
		 */ 
		function getDirectionWhenMove(moveStartPos:Point, moveEndPos:Point, defaultEntityDirection:int):int;
		
		/**
		 * 获取正确的方向
		 */
		function getDirection(direction:int, defaultEntityDirection:int):int;
	}
}