package com.dmgame.logic.grid
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class MapGridDataParse
	{
		public function MapGridDataParse()
		{
		}
		
		public static function parse(bytes:ByteArray, data:MapGridData):void
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			var gridHCount:int = bytes.readUnsignedInt();
			var gridWCount:int = bytes.readUnsignedInt();
			var gridWidth:int = bytes.readUnsignedInt();
			var gridHeight:int = bytes.readUnsignedInt();
			
			if(gridHCount == 0 || gridWCount == 0) {
				return;
			}
			
			data.create(gridHCount, gridWCount, gridWidth, gridHeight);

			var i:int, j:int;
			var value:int;
			var count:int;
			
			value = bytes.readByte();
			
			for (i=0; i<gridHCount; ++i){
				for(j=0; j<gridWCount; ++j){
					
					if(count > 7) {
						value = bytes.readByte();
						count = 0;
					}
					data.setGrid(j, i, (value & (1<<count)) > 0);
					++count;
				}
			}
		}
	}
}