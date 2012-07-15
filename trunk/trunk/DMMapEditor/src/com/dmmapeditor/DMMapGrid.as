package com.dmmapeditor
{
	import com.dmgame.asset.BaseMapConfigShell;
	import com.dmgame.asset.BaseMapGridDataShell;
	import com.dmgame.dmlogic.grid.MapGridData;
	import com.dmgame.dmlogic.utils.Rhombic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	
	import spark.utils.BitmapUtil;

	public class DMMapGrid extends Sprite
	{
		protected var gridStatus_:Array = []; // 块状态
		
		public static var gridStatusDefault:int = 0; // 块状态，默认，空闲
		
		public static var gridStatusBlock:int = 1; // 块状态，障碍
		
		public static var gridStatusShadow:int = 2; // 块状态，阴影
		
		protected var blockGridData_:BaseMapGridDataShell; // 格子配置
		
		protected var shadowGridData_:BaseMapGridDataShell; // 格子配置
		
		protected var baseMapConfig_:BaseMapConfigShell; // 地表配置
		
		protected var defaultShape_:Rhombic; // 纯形状
		
		protected var redShape_:Rhombic; // 红色形状
		
		protected var blueShape_:Rhombic; // 蓝色形状
		
		protected var gridWCount_:int; // 块宽个数
		
		protected var gridHCount_:int; // 块高个数
		
		protected var linePoint_:Array = []; // 线组成的形状
		
		protected var bitmapData_:BitmapData; // 位图
		
		public function DMMapGrid(baseMapConfig:BaseMapConfigShell, blockGridData:BaseMapGridDataShell, shadowGridData:BaseMapGridDataShell)
		{
			this.mouseEnabled = false;
			
			baseMapConfig_ = baseMapConfig;
			blockGridData_ = blockGridData;
			shadowGridData_ = shadowGridData;
			
			// 根据大小，创建格子
			gridWCount_ = (baseMapConfig_.mapWidth_ + blockGridData.gridWidth - 1) / blockGridData.gridWidth;
			gridHCount_ = (baseMapConfig_.mapHeight_ + blockGridData.gridHeight - 1) / blockGridData.gridHeight * 2 - 1;
			
			for (var i:int=0; i<gridHCount_; ++i)
			{
				gridStatus_[i] = new Array;
				
				for(var j:int=0; j<gridWCount_; ++j) 
				{
					if(blockGridData_.getGrid(j, i)) {
						gridStatus_[i][j] = gridStatusBlock;
					}
					else if(shadowGridData_.getGrid(j, i)) {
						gridStatus_[i][j] = gridStatusShadow;
					}
					else {
						gridStatus_[i][j] = gridStatusDefault;
					}
				}
			}
			
			// 形状确定
			defaultShape_ = new Rhombic(blockGridData.gridWidth, blockGridData.gridHeight, 0, 0);
			redShape_ =  new Rhombic(blockGridData.gridWidth, blockGridData.gridHeight, 0xFFFF0000);
			blueShape_ = new Rhombic(blockGridData.gridWidth, blockGridData.gridHeight, 0xFF0000FF);
			
			
			// child方式
			bitmapData_ = new BitmapData(baseMapConfig_.mapWidth_, baseMapConfig_.mapHeight_);
			var bitmap:Bitmap = new Bitmap(bitmapData_);
			bitmap.alpha = .5;
			addChild(bitmap);
			
			updateBitmapData();
		}
		
		protected function updateBitmapData():void
		{
			// child方式
			bitmapData_.fillRect(new Rectangle(0,0,baseMapConfig_.mapWidth_, baseMapConfig_.mapHeight_), 0);
			
			var i:int, j:int;
			var tx:Number, ty:Number;
			for(i = 0; i<gridHCount_; ++i)
			{
				for(j = 0; j<gridWCount_; ++j)
				{
					updateGridBitmapData(j, i);
				}
			}
		}
		
		protected function cleanGridBitmapData(gridX:int, gridY:int):void
		{
			// child方式
			
			// 清理矩形
			var tx:int = blockGridData_.gridWidth*gridX+(1-(gridY&1))*(blockGridData_.gridWidth/2);
			var ty:int = (blockGridData_.gridHeight/2)*gridY;
			bitmapData_.fillRect(new Rectangle(tx, ty, blockGridData_.gridWidth, blockGridData_.gridHeight), 0);
			
			// 相邻的4格颜色重新补上
			updateGridBitmapData(gridX-(gridY&1), gridY-1);
			updateGridBitmapData(gridX-(gridY&1), gridY+1);
			updateGridBitmapData(gridX+(1-(gridY&1)), gridY-1);
			updateGridBitmapData(gridX+(1-(gridY&1)), gridY+1);
			
			// 把自己颜色补上
			updateGridBitmapData(gridX, gridY);
		}
		
		protected function updateGridBitmapData(gridX:int, gridY:int):void
		{
			if(gridX < 0 || gridX >= gridWCount_ || gridY < 0 || gridY >= gridHCount_) {
				return;
			}
			
			// child方式
			var shape:Rhombic;
			switch(gridStatus_[gridY][gridX])
			{
				case gridStatusDefault:
					shape = defaultShape_;
					break;
				case gridStatusBlock:
					shape = redShape_;
					break;
				case gridStatusShadow:
					shape = blueShape_;
					break;
			}
			if(shape) {
				var tx:int = blockGridData_.gridWidth*gridX+(1-(gridY&1))*(blockGridData_.gridWidth/2);
				var ty:int = (blockGridData_.gridHeight/2)*gridY;
				bitmapData_.draw(shape, new Matrix(1,0,0,1,tx,ty));
			}
		}
		
		public function render(screenBitmapData:BitmapData, posx:int, posy:int, width:int, height:int):void
		{
			var sGridPosx:int = (posx - blockGridData_.gridWidth) / blockGridData_.gridWidth;
			var sGridPosy:int = (posy - blockGridData_.gridHeight) / blockGridData_.gridHeight * 2;
			
			if(sGridPosx < 0) {
				sGridPosx = 0;
			}
			if(sGridPosy < 0) {
				sGridPosy = 0;
			}
			
			var eGridPosx:int = (posx + width + blockGridData_.gridWidth) / blockGridData_.gridWidth;
			var eGridPosy:int = (posy + height + blockGridData_.gridHeight) / blockGridData_.gridHeight * 2;
			
			if(eGridPosx >= gridWCount_) {
				eGridPosx = gridWCount_ - 1;
			}
			if(eGridPosy >= gridHCount_) {
				eGridPosy = gridHCount_ - 1;
			}
			
			var i:int, j:int;
			var tx:Number, ty:Number;
			for(i = sGridPosy; i<=eGridPosy; ++i)
			{
				for(j = sGridPosx; j<=eGridPosx; ++j)
				{
					tx = blockGridData_.gridWidth*j+(1-(i&1))*(blockGridData_.gridWidth/2);
					ty = (blockGridData_.gridHeight/2)*i;
					
					var shape:Rhombic;
					switch(gridStatus_[i][j])
					{
						case gridStatusDefault:
							shape = defaultShape_;
							break;
						case gridStatusBlock:
							shape = redShape_;
							break;
						case gridStatusShadow:
							shape = blueShape_;
							break;
					}
					screenBitmapData.draw(shape, new Matrix(1,0,0,1,tx-posx,ty-posy));
				}
			}
			
			if(linePoint_.length >= 2) {
				
				for(i=0; i<(linePoint_.length-1); ++i)
				{
					var line:Shape = new Shape;
					line.graphics.lineStyle(5);
					line.graphics.moveTo(linePoint_[i].x - posx, linePoint_[i].y - posy);
					line.graphics.lineTo(linePoint_[i+1].x - posx, linePoint_[i+1].y - posy);
					screenBitmapData.draw(line);
				}
			}
		}
		
		public function setGrid(posx:int, posy:int, gridStatus:int):void
		{
			var pos:Point = Rhombic.pixelTransferCoordinateInRhombic(posx, posy, blockGridData_.gridWidth, blockGridData_.gridHeight);
			
			if(pos.x>=0 && pos.y>=0 && pos.x<gridWCount_ && pos.y<gridHCount_) {

				// 刷新状态
				if(gridStatus_[pos.y][pos.x] != gridStatus) {
					
					// 清理过去所在类型的
					switch(gridStatus_[pos.y][pos.x])
					{
						case gridStatusBlock:
							
							// 障碍只能修改为路点
							if(gridStatus != gridStatusDefault) {
								return;
							}
							blockGridData_.setGrid(pos.x, pos.y, false);
							break;
						case gridStatusShadow:
							shadowGridData_.setGrid(pos.x, pos.y, false);
							break;
					}
					
					// 添加现在所在类型的
					switch(gridStatus)
					{
						case gridStatusBlock:
							blockGridData_.setGrid(pos.x, pos.y, true);
							break;
						case gridStatusShadow:
							shadowGridData_.setGrid(pos.x, pos.y, true);
							break;
					}
					
					// 赋值
					gridStatus_[pos.y][pos.x] = gridStatus;
					
					// child方式
					cleanGridBitmapData(pos.x, pos.y);
					updateGridBitmapData(pos.x, pos.y);
				}
			}
		}
		
		public function clearGrid(posx:int, posy:int, gridStatus:int):void
		{
			var pos:Point = Rhombic.pixelTransferCoordinateInRhombic(posx, posy, blockGridData_.gridWidth, blockGridData_.gridHeight);
			
			if(pos.x>=0 && pos.y>=0 && pos.x<gridWCount_ && pos.y<gridHCount_) {
				
				// 刷新状态
				if(gridStatus_[pos.y][pos.x] == gridStatus) {
				
					// 清理过去所在类型的
					switch(gridStatus_[pos.y][pos.x])
					{
						case gridStatusBlock:
							blockGridData_.setGrid(pos.x, pos.y, false);
							break;
						case gridStatusShadow:
							shadowGridData_.setGrid(pos.x, pos.y, false);
							break;
					}
					
					// 赋值
					gridStatus_[pos.y][pos.x] = gridStatusDefault;
					
					// child方式
					cleanGridBitmapData(pos.x, pos.y);
					updateGridBitmapData(pos.x, pos.y);
				}
			}
		}
		
		public function addLinePoint(pos:Point):void
		{
			linePoint_.push(pos);
		}
		
		public function calcGridByLinePoint():void
		{
			linePoint_ = [];
		}
	}
}