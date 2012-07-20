package com.dmgame.dmlogic.entity
{
	import com.dmgame.dmlogic.astar.AStarRhombus;
	import com.dmgame.dmlogic.astar.AStarUtils;
	import com.dmgame.dmlogic.utils.Rhombic;
	
	import flash.geom.Point;

	public class MapEntityStateMoveTargetPath extends MapEntityState
	{
		protected var movePath_:Array; // 路径
		
		protected var movePathIndex_:int; // 路径索引
		
		protected var stateMoveTarget_:MapEntityStateMoveTarget; // 移动到目标点状态机
		
		public function MapEntityStateMoveTargetPath(mapEntity:MapEntity)
		{
			super(mapEntity);
			
			stateMoveTarget_ = new MapEntityStateMoveTarget(mapEntity);
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'move path';
		}
		
		/**
		 * 初始化
		 */
		public function init(targetPos:Point):Boolean
		{
			// 计算鼠标落点，转换为世界坐标
			var endRhombicPos:Point = Rhombic.pixelTransferCoordinateInRhombic(targetPos.x, targetPos.y,
				mapEntity_.map.blockGridData_.gridWidth,
				mapEntity_.map.blockGridData_.gridHeight);
			
			var startRhombicPos:Point = Rhombic.pixelTransferCoordinateInRhombic(mapEntity_.pos.x, 
				mapEntity_.pos.y,
				mapEntity_.map.blockGridData_.gridWidth,
				mapEntity_.map.blockGridData_.gridHeight);
			
			// 寻路得出路径
			var rhombicPath:Array = AStarRhombus.findPath(startRhombicPos.x, startRhombicPos.y, endRhombicPos.x, endRhombicPos.y, 
				mapEntity_.map.astarWall_);
			if(rhombicPath) {
				
				var movePath:Array = [];
				movePath.push(mapEntity_.pos.clone());
				for(var i:int=0; i<rhombicPath.length; ++i)
				{
					movePath.push(Rhombic.coordinateTransferPixelInRhombic(rhombicPath[i].x, rhombicPath[i].y, 
						mapEntity_.map.blockGridData_.gridWidth,
						mapEntity_.map.blockGridData_.gridHeight));
				}
				movePath.push(targetPos.clone());
				
				movePath_ = AStarUtils.getOptimizeCrossPotArr(movePath, 1, mapEntity_.map.astarWall_);
				return true;
			}
			return false;
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			movePathIndex_ = 0;
			stateMoveTarget_.init(movePath_[movePathIndex_]);
			stateMoveTarget_.enter();
		}
		
		/**
		 * 离开
		 */
		override public function leave():void
		{
		}
		
		/**
		 * 更新
		 */
		override public function update():Boolean
		{
			if(stateMoveTarget_.update()) {
				
				++movePathIndex_;
				if(movePathIndex_ >= movePath_.length) {
					return true;
				}
				stateMoveTarget_.init(movePath_[movePathIndex_]);
				stateMoveTarget_.enter();
			}
			return false;
		}
	}
}