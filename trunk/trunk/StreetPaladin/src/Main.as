package
{
	import flash.display.MovieClip;
	import flash.events.Event;

	[SWF(width="1250",height="650",frameRate="30",backgroundColor="#000000")]
	public class Main extends MovieClip
	{
		public function Main()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			var main:StreetPaladin = new StreetPaladin(stage);
			addChild(main);
		}
	}
}