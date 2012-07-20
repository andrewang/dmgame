package com.dmgame.dmlogic.entity
{
	import flash.geom.Point;

	public class MapEntity8Directions implements MapEntityDirections
	{
		public function MapEntity8Directions()
		{
			super();
		}
		
		/**
		 * 根据角度值获取角色的方向
		 */ 
		public function getDirectionWhenMove(moveStartPos:Point, moveEndPos:Point, defaultEntityDirection:int):int
		{
			var radian:Number = Math.atan2(moveEndPos.y-moveStartPos.y, moveEndPos.x-moveStartPos.x);
			var angle:int = int(radian*180/Math.PI)+90;
			
			if(angle<-22.5) angle+=360;
			
			if(angle>=-22.5 && angle<22.5){
				return EntityDirections.up;
			}else if(angle>=22.5 && angle<67.5){
				return EntityDirections.rightUp;
			}else if(angle>=67.5 && angle<112.5){
				return EntityDirections.right;
			}else if(angle>=112.5 && angle<157.5){
				return EntityDirections.rightDown;
			}else if(angle>=157.5 && angle<202.5){
				return EntityDirections.down;
			}else if(angle>=202.5 && angle<247.5){
				return EntityDirections.leftDown;
			}else if(angle>=247.5 && angle<292.5){
				return EntityDirections.left;
			}else{
				return EntityDirections.leftUp;
			}
		}
		
		/**
		 * 获取正确的方向
		 */
		public function getDirection(direction:int, defaultEntityDirection:int):int
		{
			return direction;
		}
	}
}