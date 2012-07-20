package com.dmgame.dmlogic.astar
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.charts.AreaChart;
	import mx.events.IndexChangedEvent;
	
	public class AStarRhombus
	{
		public function AStarRhombus()
		{
		}
		
		private static const nodeOpenIndex:int = 1;
		private static const nodeClosedIndex:int = 2;
		private static const nodeIdIndex:int = 0;
		private static const LIMITE_POT_NUM:int = 14000;
		private static const HOR_COST:Number = 1;
		private static const VER_COST:Number = 1; 
		private static const DOAG_COST:Number = Math.SQRT2;
		
		private static var _nodeMap:Array;
		private static var _grid:AstarWall;
		
		private static var whileNum:int;
		
		private static var _yPotList:Array;
		private static var _xPotList:Array;
		private static var _FValue:Array;
		private static var _GValue:Array;
		private static var _parentIdList:Array; 
		private static var _openId:int;
		private static var _openListLength:int = 0;
		private static var _openList:Array;
		private static var _closeList:Array;
		
		public static function get visited():Array{ return null;}
		
		private static function cleanReferData():void
		{
			_grid = null;
			whileNum = 0;
		}
		private static function initList():void
		{
			whileNum = 0
			_openListLength = 0;
			_yPotList = [];
			_xPotList = [];
			_FValue= [];
			_GValue= [];
			_openList = [];
			_closeList = [];
			_parentIdList= []; 
			_nodeMap = [];
			_openId = -1;
		}
		
		private static function destroyLists():void 
		{
			_openList = null;
			_nodeMap = null;
			_yPotList = null;
			_xPotList = null;
			_FValue= null;
			_GValue= null;
			_openList = null;
			_closeList = null;
			_parentIdList= null; 
			_nodeMap = null;
			_openId = -1;
		}
		private static function testOuput(arr:Array):void
		{
			for(var i:int = 0; i < arr.length; i++){
				//trace("(" + AStarNode(arr[i]).x + "," + AStarNode(arr[i]).y + ")F:=" + AStarNode(arr[i]).f );
			}
		}
		
		private static function aheadNote(p_index:int) : void
		{
			var father : int;
			var change : int;
			//如果节点不在列表最前
			while(p_index > 1){
				//父节点的位置
				father = Math.floor(p_index/2);
				//如果该节点的F值小于父节点的F值则和父节点交换
				if (getScore(p_index) < getScore(father)){
					change = _openList[p_index - 1];
					_openList[p_index - 1] = _openList[father - 1];
					_openList[father - 1] = change;
					p_index = father;
				}else{
					break;
				}
			}
		}
		private static function getScore(p_index : int) : int
		{
			return _FValue[_openList[p_index - 1]];
		}
		
		private static function backNote() : void
		{
			//尾部的节点被移到最前面
			var checkIndex:int = 1;
			var tmp:int;
			var change:int;
			
			while(true){
				tmp = checkIndex;
				//如果有子节点
				if (2 * tmp <= _openListLength){
					//如果子节点的F值更小
					if(getScore(checkIndex) > getScore(2 * tmp)){
						//记节点的新位置为子节点位置
						checkIndex = 2 * tmp;
					}
					//如果有两个子节点
					if (2 * tmp + 1 <= _openListLength){
						//如果第二个子节点F值更小
						if(getScore(checkIndex) > getScore(2 * tmp + 1)){
							//更新节点新位置为第二个子节点位置
							checkIndex = 2 * tmp + 1;
						}
					}
				}
				//如果节点位置没有更新结束排序
				if (tmp == checkIndex){
					break;
				}else{
					//反之和新位置交换，继续和新位置的子节点比较F值
					change = _openList[tmp - 1];
					_openList[tmp - 1] = _openList[checkIndex - 1];
					_openList[checkIndex - 1] = change;
				}
			}
		}
		
		public static function findPath(sx:int, sy:int, ex:int, ey:int, grid:AstarWall):Array
		{
			_grid = grid;
			//_startNode = _grid.startNode;
			//_endNode = _grid.endNode;
			if(sx<0 || sx>_grid.numCols || sy<0 || sy>_grid.numRows)return null;
			if(ex<0 || ex>_grid.numCols || ey<0 || ey>_grid.numRows)return null;
			
			initList();
			var curId:int = 0;
			var curXPot:int;
			var curYPot:int;
			var fVlaue:Number=0;
			var gValue:Number=0;
			var aroundNodes:Array;
			var searchId:int;
			addOpenList(sx, sy, 0, 0, 0);
			
			
			while(_openListLength){
				whileNum++;
				if(whileNum > LIMITE_POT_NUM){
					return null;
				}
				
				curId = _openList[0];
				addCloseList(curId);
				curXPot = _xPotList[curId];
				curYPot = _yPotList[curId];
				//取得周围8个节点，可能小于8个
				aroundNodes = getAroundsNode(curXPot, curYPot);
				//trace("open数目："+_open.length);
				for each (var note : Array in aroundNodes){
					gValue = getGValue(curYPot, _GValue[curId], note[1]);
					fVlaue = gValue + euclidian(note[0], note[1], ex, ey);
					if(isList(note[0], note[1], nodeOpenIndex)){
						searchId = _nodeMap[note[1]][note[0]][nodeIdIndex];
						if(fVlaue < _FValue[searchId]){
							_FValue[searchId] = fVlaue;
							_GValue[searchId] = gValue;
							_parentIdList[searchId] = curId;
							aheadNote(getOpenListIndex(searchId));
						}
					}else{
						searchId = addOpenList(note[0], note[1], fVlaue, gValue, curId);
					}
					if(note[0] == ex && note[1] == ey){
						//把终止节点加入到关闭数组中，后面统一清除F值和父节点值
						//trace("寻路节点数："+whileNum);
						//trace("currentNodeId:"+curId)
						return getPath(sx, sy, searchId);
						destroyLists();
					}
				}
			}
			return null;
		}
		private static function getOpenListIndex(nodeId:int) : int
		{
			var i : int = 1;
			var index:int = _openList.indexOf(nodeId);
			return index;
		}
		
		private static function addCloseList(sId:int):void
		{
			_openListLength--;
			var noteX : int = _xPotList[sId];
			var noteY : int = _yPotList[sId];
			_nodeMap[noteX][noteY][nodeOpenIndex] = false;
			_nodeMap[noteX][noteY][nodeClosedIndex] = true;
			
			if (_openListLength <= 0) {
				_openListLength = 0;
				_openList = [];
				return;
			}
			
			_openList[0] = _openList.pop();
			backNote();
		}
		
		private static function addOpenList(xPot:int, yPot:int, FValue:Number, GValue:Number, parentId:int):int
		{
			_openListLength++;
			_openId++;
			
			if (_nodeMap[xPot] == null)	{
				_nodeMap[xPot] = new Array();
			}
			_nodeMap[xPot][yPot] = new Array();
			_nodeMap[xPot][yPot][nodeIdIndex] = _openId;
			_nodeMap[xPot][yPot][nodeClosedIndex] = true;
			
			_xPotList.push(xPot);
			_yPotList.push(yPot);
			_FValue.push(FValue);
			_GValue.push(GValue);
			_parentIdList.push(parentId);
			_openList.push(_openId);
			
			aheadNote(_openListLength);
			return _openId;
		}
		
		/**
		 *	根据当前节点和正在探索的节点找到G值 
		 * @param currentNode
		 * @param searchNode
		 * @return 
		 * 
		 */		
		private static function getGValue(currentY:int, currentGValue:Number, searchY:int):int
		{
			if (currentY == searchY){
				// 横向 左右
				return (currentGValue + HOR_COST * 2);
			}else if(currentY+2 == searchY || currentY-2 == searchY){
				// 竖向上下
				return currentGValue + VER_COST * 2;
			}else{
				// 斜向左上左下右上右下
				return currentGValue + DOAG_COST;
			}
		}
		
		/**
		 *	 搜索一个当前格子8个方向的格子的F值，搜索完了，将当前格子从OPEN数组中放入CLOSE数组中
		 * 		正方向鸽子和斜方向格子的搜索方法稍微有些不同
		 * @param currentNode 当前格子结点
		 * 
		 */		
		private static function getAroundsNode(currentXPot:int, currentYPot:int):Array
		{
			var aroundNodes:Array = new Array();
			var checkX:int;
			var checkY:int;
			
			var checkLeftUp:Boolean, checkRightUp:Boolean, checkLeftDown:Boolean, checkRightDown:Boolean;
			
			//左上
			checkX = currentXPot-(currentYPot&1);
			checkY = currentYPot-1;
			if(_grid.notIsBorder(checkX, checkY)) {
				if(_grid.isWalk(checkX,checkY)) {
					checkLeftUp = true;
					if(!isList(checkX, checkY, nodeClosedIndex)) {
						aroundNodes.push([checkX, checkY]);
					}
				}
			}
			
			//右上
			checkX = currentXPot + (1-(currentYPot&1));
			checkY = currentYPot-1;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY)) {
					checkRightUp = true;
					if(!isList(checkX, checkY, nodeClosedIndex)) {
						aroundNodes.push([checkX, checkY]);
					}
				}
			}
			
			//左下
			checkX = currentXPot-(currentYPot&1);
			checkY = currentYPot+1;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY)) {
					checkLeftDown = true;
					if(!isList(checkX, checkY, nodeClosedIndex)) {
						aroundNodes.push([checkX, checkY]);
					}
				}
			}
			
			//右下
			checkX = currentXPot + (1-(currentYPot&1));
			checkY = currentYPot+1;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY)) {
					checkRightDown = true;
					if(!isList(checkX, checkY, nodeClosedIndex)) {
						aroundNodes.push([checkX, checkY]);
					}
				}
			}
			
			//上
			checkX = currentXPot;
			checkY = currentYPot-2;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY) && !isList(checkX, checkY, nodeClosedIndex) && (checkLeftUp || checkRightUp)) {
					aroundNodes.push([checkX, checkY]);
				}
			}
			
			//左
			checkX = currentXPot-1;
			checkY = currentYPot;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY) && !isList(checkX, checkY, nodeClosedIndex) && (checkLeftUp || checkLeftDown)) {
					aroundNodes.push([checkX, checkY]);
				}
			}
			
			//右
			checkX = currentXPot+1;
			checkY = currentYPot;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY) && !isList(checkX, checkY, nodeClosedIndex) && (checkRightUp || checkRightDown)) {
					aroundNodes.push([checkX, checkY]);
				}
			}
			
			//下
			checkX = currentXPot;
			checkY = currentYPot+2;
			if(_grid.notIsBorder(checkX, checkY)){
				if(_grid.isWalk(checkX,checkY) && !isList(checkX, checkY, nodeClosedIndex) && (!checkLeftDown || checkRightDown)) {
					aroundNodes.push([checkX, checkY]);
				}
			}
			return aroundNodes;
		}
	
		private static function getPath(sx:int, sy:int, nodeId:int):Array
		{
			var path:Array = [];
			var nodeX:int = _xPotList[nodeId];
			var nodeY:int = _yPotList[nodeId];
			while(nodeX != sx || nodeY != sy){
				path.unshift(new Point(nodeX, nodeY));
				nodeId = _parentIdList[nodeId];
				nodeX = _xPotList[nodeId];
				nodeY = _yPotList[nodeId];
				
			}
			path.unshift(new Point(sx, sy));
			destroyLists();
			return path;
		}
		
		private static function isList(x:int, y:int, nodeInde:int):Boolean
		{
			if(_nodeMap[x] == null)return false;
			if(_nodeMap[x][y] == null)return false;
			return _nodeMap[x][y][nodeInde];
		}
		
		private static function addList(x:int, y:int, nodeInde:int):void
		{
			if (_nodeMap[x] == null){
				_nodeMap[x] = new Array();
			}
			_nodeMap[x][y] = new Array();
			_nodeMap[x][y][nodeInde] = true;
		}
		
		
		/**
		 *	欧几里德 
		 * @param searchNode
		 * @param referNode
		 * @return 
		 */		
		private static function euclidian(searchX:int, searchY:int, endX:int, endY:int):Number
		{
			var a:int = Math.abs(searchX- endX);
			var b:int = Math.abs(searchY - endY);
			var c:int = Math.sqrt(a * a + b * b) * DOAG_COST;
			return c;
		}
		
		/**
		 *	曼哈顿 
		 * @param searchNode
		 * @param referNode
		 * @return 
		 * 
		 */		
		private static function manhattan(searchX:int, searchY:int, endX:int, endY:int):Number
		{
			return 	Math.abs(searchX - endX) * HOR_COST +  
				Math.abs(searchY - endY) * HOR_COST;
		}
		
		/**
		 *	对角 
		 * @param searchNode
		 * @param referNode
		 * @return 
		 */		
		private static function diagonal(searchX:int, searchY:int, endX:int, endY:int):Number
		{
			var dx:Number = Math.abs(searchX - endX);
			var dy:Number = Math.abs(searchY - endY);
			var dz:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return DOAG_COST * dz + HOR_COST * (straight - 2 * dz);
		}
	}
}