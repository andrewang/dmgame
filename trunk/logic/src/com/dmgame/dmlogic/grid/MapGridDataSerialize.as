package com.dmgame.dmlogic.grid
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class MapGridDataSerialize
	{
		public function MapGridDataSerialize()
		{
		}
		
		public static function serialize(bytes:ByteArray, data:MapGridData):void
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeUnsignedInt(data.gridHCount);
			bytes.writeUnsignedInt(data.gridWCount);
			bytes.writeUnsignedInt(data.gridWidth);
			bytes.writeUnsignedInt(data.gridHeight);
			
			var i:int, j:int;
			var value:int;
			var count:int;
			
			for (i=0; i<data.gridHCount; ++i){
				for(j=0; j<data.gridWCount; ++j){
					
					if(count > 7) {
						bytes.writeByte(value);
						
						value = 0;
						count = 0;
					}
					
					if(data.getGrid(j, i)) {
						value |= (1<<count);
					}
					++count;
				}
			}
			if(count > 0) {
				bytes.writeByte(value);
			}
		}
	}
}