package com.dmgame.asset
{
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	import com.dmgame.dmlogic.grid.MapGridData;
	import com.dmgame.dmlogic.grid.MapGridDataParse;
	import com.dmgame.dmlogic.grid.MapGridDataSerialize;

	public class BaseMapGridDataShell extends MapGridData
	{
		public function BaseMapGridDataShell()
		{
			super();
		}
		
		/**
		 * 读取
		 */
		public function load(fileName:String):Boolean
		{
			var stream:FileStream = new FileStream();
			var file:File = new File(fileName);
			if(!file.exists) {
				return false;
			}
			stream.open(file, FileMode.READ);
			
			var bytes:ByteArray = new ByteArray;
			stream.readBytes(bytes);
			stream.close();
			
			MapGridDataParse.parse(bytes, this);
			return true;
		}
		
		/**
		 * 保存
		 */
		public function save(fileName:String):void
		{
			var bytes:ByteArray = new ByteArray;
			MapGridDataSerialize.serialize(bytes, this);
		
			var stream:FileStream = new FileStream();
			var file:File = new File(fileName);               
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(bytes);
			stream.close();
		}
	}
}