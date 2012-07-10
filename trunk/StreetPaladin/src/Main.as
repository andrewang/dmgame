package
{
	import flash.display.MovieClip;
	import flash.events.Event;

	[SWF(width="1250",height="650",frameRate="60",backgroundColor="#000000")]
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
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function enterFrame(event:Event):void
		{
			
		}
	}
}