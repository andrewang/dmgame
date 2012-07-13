package com.dmgame.logic.astar
{
	
	import com.dmgame.logic.astar.AStarGridBase;
	import com.dmgame.logic.utils.Rhombic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.Container;
	import mx.core.UIComponent;

	public class AStarUtils
	{
		public function AStarUtils()
		{
		}
		
		public static function sortMapObstacle(parentContainer:DisplayObjectContainer, arr:Array):void
		{
			arr.sortOn("y", Array.NUMERIC);	
			for(var i:int=0; i<arr.length; i++){
				parentContainer.addChild(arr[i]);
			}
		}
		
		/**
		 *	在一个数组的两两个点里面平均插入 insertIntoPotNum个点
		 * @param insertIntoPotNum 两点之间需要插入的点数
		 * @param pathArray 
		 * @return 
		 * 
		 */		
		public static function insertIntoPointsBetweenTwoPoints(insertIntoPotNum:int, pathArray:Array):Array
		{
			var first:Point;
			var two:Point;
			var resArray:Array = [];
			for(var i:int = 0; i < pathArray.length; i ++){
				first = pathArray[i];
				resArray.push(first);
				if(i + 1 < pathArray.length){
					two = pathArray[i + 1];
				}else{
					return resArray;
				}
				for(var n:int = 0; n < insertIntoPotNum; n ++){
					var insertPot:Point = new Point();
					insertPot.x = first.x + (1+n)/(insertIntoPotNum+1)*(two.x - first.x);
					insertPot.y = first.y + (1+n)/(insertIntoPotNum+1)*(two.y - first.y);
					resArray.push(insertPot);
				}
			}
			return null;
		}
		
		/**
		 * 优化，整理AStar的路径 
		 * @param rawPath  AStar路径 
		 * @param aStarGrid
		 * @param len 点与点之间的距离
		 * @param sx 自己的当前X坐标
		 * @param sy 自己的当前Y坐标
		 * @return 
		 * 
		 */		
		public static function getAStarOptimizePath(rawPath:Array, aStarGrid:AStarGridBase, len:Number, spx:Number, spy:Number):Array
		{
			if(!rawPath || !aStarGrid || len < 0 || !spx || spx<0 || !spy || spy<0)return null;
			//由于起始点的差异，所以把目标正确起始点放到像素路径里面去
			var aStarNode:Point;
			var PixelPath:Array = [new Point(0,0)];
			var pot:Point;
			for(var i:int=1; i< rawPath.length; i++){
				aStarNode = rawPath[i];
				pot = Rhombic.coordinateTransferPixelInRhombic(aStarNode.x, aStarNode.y, aStarGrid.nodeWidth, aStarGrid.nodeHeight);
				PixelPath.push(pot);
			}
			//把当前点放到第一个位置
			if(PixelPath.length > 1){
				PixelPath[0].x = spx;
				PixelPath[0].y = spy;
			}
			//第二次优化调整
			var optimizeCrossArr:Array = AStarUtils.getOptimizeCrossPotArr(PixelPath, len, aStarGrid);
			var optimizePath:Array = AStarUtils.insertPotByLen(optimizeCrossArr, len);
			//删除自己当前位置
			optimizePath.shift();
			return optimizePath;
		}
		
		
		/**
		 *	在点与点之间插入定长的N个点
		 * 	注：传入参数点与点之间可以不同距离，
		 * @param crossArr 优化过后的转折点
		 * @return 返回路径数组
		 */		
		public static function insertPotByLen(crossArr:Array, len:Number):Array
		{
			var first:Point;
			var two:Point;
			var resArray:Array = [];
			var totalLen:Number;
			var insertIntoPotNum:Number;
			for(var i:int = 0; i < crossArr.length; i ++){
				first = crossArr[i];
				resArray.push(first);
				if(i + 1 < crossArr.length){
					two = crossArr[i + 1];
				}else{
					return resArray;
				}
				totalLen = Math.sqrt((first.x-two.x)*(first.x-two.x)+(first.y-two.y)*(first.y-two.y));
				insertIntoPotNum = totalLen / len;
				for(var n:int = 0; n < insertIntoPotNum; n ++){
					var insertPot:Point = new Point();
					insertPot.x = first.x + (1+n)/(insertIntoPotNum+1)*(two.x - first.x);
					insertPot.y = first.y + (1+n)/(insertIntoPotNum+1)*(two.y - first.y);
					resArray.push(insertPot);
				}
			}
			return null;
		}
		
		/**
		 *	 去掉多余的转折点，主要判断相关转折点之间的路径是否是通路
		 * 	该方法没有改变传入参数
		 * @param crossPathArr 经过一次处理的转折点数组转折点数组, 传入参数必须“像素”路径
		 * @return 返回转折点数组
		 * 
		 */		
		public static function getOptimizeCrossPotArr(crossPathArr:Array, len:Number, aStarGrid:AStarGridBase):Array
		{
			//如果路径长度小于就不需要优化转折点路径
			if(crossPathArr.length<3)return crossPathArr;
			//正在检查的点的索引
			var checkPotIndex:int=0;
			//路径转折点数组
			var optCrossPathArr:Array = [];
			//开始检测的点（起点，转折点）
			var judgeStartPot:Point;
			//正在检查的点
			var judgingPot:Point;
			//是否遇到转折点
			var isFirstJudge:Boolean = true;
			
			while(checkPotIndex < crossPathArr.length){
				if(isFirstJudge){
					if(checkPotIndex-1>0){
						//把不可通路径的上一个路径点放到数组里面
						optCrossPathArr.push(crossPathArr[checkPotIndex-1]);
					}
					judgeStartPot = crossPathArr[checkPotIndex];
					optCrossPathArr.push(judgeStartPot);
					//跳过下一个判断点
					checkPotIndex+=2;
					//判断该点是否存在
					if(checkPotIndex >= crossPathArr.length)break;
					judgingPot = crossPathArr[checkPotIndex];
				}else{
					judgingPot = crossPathArr[checkPotIndex];
				}
				var isWalk:Boolean = linePathIsWalk(judgeStartPot.x, judgeStartPot.y, judgingPot.x, judgingPot.y, len, aStarGrid);
				if(isWalk){
					checkPotIndex++;
					isFirstJudge = false;
				}else{
					isFirstJudge = true;
				}
			}
			//把路径终点放到数组里面//如果终点没不在数组里面，则把终点放到数组里面
			if(crossPathArr[crossPathArr.length-1] != optCrossPathArr[optCrossPathArr.length-1]){
				optCrossPathArr.push(crossPathArr[crossPathArr.length-1]);
			}
			return optCrossPathArr;
		}
		
		/**
		 * 	生成直线路径，然后判定该路径上所有点能否行走，如果有一个不能行走，则返回NULL,如果所有点都能
		 * 	行走，则生成该路径，返回数组 
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @param len
		 * @return 
		 * 
		 */		
		public static function linePathIsWalk(sx:Number, sy:Number, ex:Number, ey:Number, len:int, aStarGrid:AStarGridBase):Boolean
		{
			if(len <= 0){
				throw new Event("insert point is not ilegal");
			}
			//起点和终点的长度
			var pathLen:Number = Math.sqrt((sx-ex)*(sx-ex)+(sy-ey)*(sy-ey));
			//中间插入的点数量
			var insertPotNum:int = pathLen / len;
			insertPotNum--;
			if(insertPotNum<0)insertPotNum = 0;
			//点与点的变化量
			var changX:Number = (ex-sx)/pathLen*len;
			var changeY:Number = (ey-sy)/pathLen*len;
			var changePotNum:int = 1;
			var newX:Number;
			var newY:Number;
			while(changePotNum <= insertPotNum){
				newX = sx + changX*changePotNum;
				newY = sy + changeY*changePotNum;
				//把像素坐标转化为格子坐标，判断该格子是否可以通行
				var sPot:Point = Rhombic.pixelTransferCoordinateInRhombic(newX, newY, aStarGrid.nodeWidth, aStarGrid.nodeHeight);
				if(!aStarGrid.getWalkable(sPot.x, sPot.y)){
					return false;
				}
				changePotNum++;
			}
			return true;
		}
		
		/**
		 *	 搜集路径的转折点,该方法没有改变传入参数
		 * 	注：该转折点没有经过优化，该优化方法在getOptimizeCrossPotArr里面实现
		 * @param rawPathArr A*出来的最原始的路径数组,
		 * 					传入参数是”表格坐标“或者”像素坐标“
		 * @return 返回转折点数组
		 * 
		 */		
		public static function getRawCrossPotArr(rawPathArr:Array):Array
		{
			//如果路径长度小于就不需要优化转折点路径
			if(rawPathArr.length<3)return rawPathArr;
			//正在检查的点的索引
			var checkPotIndex:int=1;
			//路径转折点数组
			var crossPotArr:Array = [];
			//开始检测的点（起点，转折点）,此处数据类型为Object，是为了兼容point类型，AStarNode类型
			var judgeStartPot:Object;
			//正在检查的点
			var judgingPot:Object;
			//本轮检测的斜率
			var slope:Number = 0;
			//当前检测点的斜率
			var currentSlop:Number = 0;
			//是否遇到转折点
			var isFirstJudge:Boolean = true;
			while(checkPotIndex < rawPathArr.length){
				if(isFirstJudge){
					judgeStartPot = rawPathArr[checkPotIndex-1];
					crossPotArr.push(judgeStartPot);
				}
				judgingPot = rawPathArr[checkPotIndex];
				currentSlop = (judgingPot.y-judgeStartPot.y)/(judgingPot.x-judgeStartPot.x);
				if(isFirstJudge){
					slope = currentSlop;
				}
				isFirstJudge = false;
				//该参数0.2表示斜率的变化范围，如果为0就很精准的在一条直线上
				if(Math.abs(currentSlop-slope)>0){
					isFirstJudge = true;
				}else{
					checkPotIndex++;
				}
			}
			//把终点也放到转折点数组里面
			crossPotArr.push(rawPathArr[rawPathArr.length-1]);
			return crossPotArr;
		}
		
		/**
		 *	 如果点击在不能走的地方，则走到可以行走的最近像素点的地方
		 * 	
		 * @param aStarGrid 
		 * @param mouseClickX 鼠标点击的X左标
		 * @param mouseClickY 鼠标点击的Y坐标
		 * @param rolePixelX 角色现在站立的像素点X
		 * @param rolePixelY 角色现在站立的像素点Y
		 * @return 返回可行走的路径终点
		 * 
		 */		
		public static function calculateEndPot(aStarGrid:AStarGridBase, mouseClickX:Number, mouseClickY:Number, rolePixelX:Number, rolePixelY:Number):Point
		{
			var mousePot:Point = Rhombic.pixelTransferCoordinateInRhombic(mouseClickX, mouseClickY, aStarGrid.nodeWidth, aStarGrid.nodeHeight);
			var rolePot:Point = Rhombic.pixelTransferCoordinateInRhombic(rolePixelX, rolePixelY, aStarGrid.nodeWidth, aStarGrid.nodeHeight);
			//检查点击的格子是否超出范围
			if(mousePot.x > 0 && mousePot.y > 0 && mousePot.x <= aStarGrid.numCols-1 && mousePot.y <= aStarGrid.numRows-1 && aStarGrid.getWalkable(mousePot.x, mousePot.y)){
				return mousePot;
			}
			var currentPot:Point = mousePot;
			var temPot:Point = new Point();
			var minX:int;
			var minY:int;
			var maxX:int;
			var maxY:int;
			for(var k:int=0; k<uint.MAX_VALUE; k++){
				minX = mousePot.x-k;
				minY = mousePot.y-k;
				maxX = mousePot.x+k;
				maxY = mousePot.y+k;
				if(minX<0)minX = 0;
				if(minY<0)minY = 0;
				if(maxX>aStarGrid.numCols - 1)maxX = aStarGrid.numCols - 1;
				if(maxY>aStarGrid.numRows - 1)maxY = aStarGrid.numRows - 1;
				var i:int=0;
				
				for(i=minX; i<maxX; i++){
					//检查上面一横排
					temPot.x = i;
					temPot.y = minY;
					if(temPot.x > 0 && temPot.y > 0 && (temPot.x <= aStarGrid.numCols - 1) && (temPot.y <= aStarGrid.numRows - 1) && aStarGrid.getWalkable(temPot.x, temPot.y)){
						return temPot;
					}
					//已经是最近点了
					if(temPot.x == rolePot.x && temPot.y == rolePot.y)return null;
					//检查下面一横排
					temPot.x = i;
					temPot.y = maxY;
					if(temPot.x > 0 && temPot.y > 0 && (temPot.x <= aStarGrid.numCols - 1) && (temPot.y <= aStarGrid.numRows - 1) && aStarGrid.getWalkable(temPot.x, temPot.y)){
						return temPot;
					}
					//已经是最近点了
					if(temPot.x == rolePot.x && temPot.y == rolePot.y)return null;
				}
				
				for(i=minY; i<maxY; i++){
					//检查左边一竖排
					temPot.x = minX;
					temPot.y = i;
					if(temPot.x > 0 && temPot.y > 0 && (temPot.x <= aStarGrid.numCols - 1) && (temPot.y <= aStarGrid.numRows - 1) && aStarGrid.getWalkable(temPot.x, temPot.y)){
						return temPot;
					}
					//已经是最近点了
					if(temPot.x == rolePot.x && temPot.y == rolePot.y)return null;
					//检查右边一竖拍排
					temPot.x = minX;
					temPot.y = i;
					if(temPot.x > 0 && temPot.y > 0 && (temPot.x <= aStarGrid.numCols - 1) && (temPot.y <= aStarGrid.numRows - 1) && aStarGrid.getWalkable(temPot.x, temPot.y)){
						return temPot;
					}
					//已经是最近点了
					if(temPot.x == rolePot.x && temPot.y == rolePot.y)return null;
				}
			}
			return null;
		}
		
	}
}