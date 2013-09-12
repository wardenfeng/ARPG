package test
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.KeyBind;

	import flash.events.Event;
	import flash.geom.Point;

	import animation.animationtypes.MonsterAnimation;

	public class Test
	{
		public function Test()
		{
			Cc.bindKey(new KeyBind("t"), testnpc);
		}

		private function testnpc():void
		{
			var npc:MonsterAnimation=new MonsterAnimation("1001");
			npc.floorPoint=new Point(200, 200);
			UIAllRefer.stage.addChild(npc);

			UIAllRefer.stage.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				npc.animationController.enterFrame();
			});
		}

	}
}
