package com.dmmapeditor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;

	public class DMMapTool
	{
		public static var singleton_:DMMapTool; // 单件
		
		public function DMMapTool()
		{
			singleton_ = this;
		}
		
		public function cut(bitmapData:BitmapData, targetPath:String, tileWidth:int, tileHeight:int):void
		{
			// 计算大小
			var tileHCount:int = (bitmapData.height + tileHeight - 1) / tileHeight;
			var tileWCount:int = (bitmapData.width + tileWidth - 1) / tileWidth;
			
			var tileBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight);
			
			for(var i:int=0; i<tileHCount; ++i){
				for(var j:int=0; j<tileWCount; ++j){
					
					// 拷贝到单元格上
					tileBitmapData.fillRect(new Rectangle(0,0,tileBitmapData.width,tileBitmapData.height), 0);
					tileBitmapData.copyPixels(bitmapData, new Rectangle(j*tileWidth, i*tileHeight, tileWidth, tileHeight), new Point(0,0));
					
					// 写为jpg
					var jpgenc:JPEGEncoder = new JPEGEncoder(80);
					var byteArray:ByteArray = jpgenc.encode(tileBitmapData);
					var file:File = new File(targetPath+"/"+i+"_"+j+".jpg");
					var fs:FileStream = new FileStream();
					fs.open(file,FileMode.WRITE);
					fs.position = 0;
					fs.writeBytes(byteArray);
					fs.close();
				}
			}
		}
		
		public function scale2Mosaic(bitmapData:BitmapData, targetPath:String, size:int):void
		{
			// 计算大小
			var scale:Number;
			
			if(bitmapData.width > bitmapData.height) {
				scale = size / bitmapData.width;
			}
			else {
				scale = size / bitmapData.height;
			}
			
			var bitmap:Bitmap = new Bitmap(bitmapData);

			var mosaic:BitmapData = new BitmapData(bitmapData.width*scale, bitmapData.height*scale);
			mosaic.draw(bitmap, new Matrix(scale,0,0,scale)); // 读取成功，绘制缩略图
			
			// 写为jpg
			var jpgenc:JPEGEncoder = new JPEGEncoder(80);
			var byteArray:ByteArray = jpgenc.encode(mosaic);
			var file:File = new File(targetPath+"/s.jpg");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.position = 0;
			fs.writeBytes(byteArray);
			fs.close();
		}
	}
}