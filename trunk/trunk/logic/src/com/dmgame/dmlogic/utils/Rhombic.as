package com.dmgame.dmlogic.utils
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Rhombic extends Shape
	{
		public function Rhombic(width:uint, height:uint, color:uint, alpha:Number=1.0)	
		{
			graphics.beginFill(color, alpha); //&0xFFFFFF
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.moveTo(width>>1,0);
			graphics.lineTo(width,height>>1);
			graphics.lineTo(width>>1,height);
			graphics.lineTo(0,height>>1);
			graphics.endFill();
		}
			
		public static function getRhombicLocal(rowVar:int, colVar:int, nodeWidth:Number, nodeHieght:Number):Point
		{
			var tx:Number = colVar*nodeWidth+(1-(rowVar&1))*(nodeWidth/2)
			var ty:Number = (nodeHieght/2)*rowVar;
			return new Point(tx, ty);
		}

		public static function coordinateTransferPixelInRhombic(nodeX:int, nodeY:int, nodeWidth:int, nodeHeight:int):Point
		{
			if(nodeY&1) {
				return new Point(nodeWidth*nodeX+(nodeWidth/2), ((nodeY+1)/2)*nodeHeight);
			} 
			else {
				return new Point(nodeWidth*(nodeX+1), nodeY*(nodeHeight/2)+(nodeHeight/2));
			}
		}
		
		public static function pixelTransferCoordinateInRhombic(pixelX:Number, pixelY:Number, width:int, height:int):Point
		{
			/*转化为矩形的宽和高*/
			var recW:Number = width / 2;   
			var recH:Number = height / 2;
			
			/*矩形坐标*/
			var recX:int = int(pixelX / recW);
			var rexY:int = int(pixelY / recH);
			
			if(rexY + recX & 1){
				if((pixelY % recH) > ((- recH / recW * (pixelX % recW)) + recH)){
					return new Point(int(recX/2), rexY);
				}else{
					if(rexY&1){
						return new Point(int(recX/2)-1, rexY-1);
					}else{
						return new Point(int(recX/2), rexY-1);
					}
				}
			}else{
				if((pixelY % recH) > (recH / recW * (pixelX % recW))){
					if(rexY&1){
						return new Point(int(recX/2), rexY);
					}else{
						return new Point(int(recX/2)-1, rexY);
					}
				}else{
					return new Point(int(recX/2), rexY-1);
				}
			}
		}
	}
}