package bc.game.init 
{
	import bc.core.device.BcDevice;
	import bc.core.device.BcEntryPoint;
	import bc.game.BcGame;
	import bc.game.asset.BcGameAsset;
	import bc.game.asset.BcPreloaderAsset;

	import flash.events.Event;

	/**
	 * @author Elias Ku
	 */
	//[Frame(factoryClass="bc.init.BcPreloaderFactory")]
	[SWF(backgroundColor="#000000", width="640", height="480")] 
	public class BitCaptains extends BcEntryPoint 
	{
		public function BitCaptains()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function initialize1():void
		{
			new BcGameAsset(initialize2);
		}
		
		private function initialize2():void
		{
			new BcGame();
		}
		
		private function addedToStageHandler(event:Event):void
		{
			// cleanup
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			BcDevice.initialize(this);
			
			if(BcDevice.impl)
			{
				new BcPreloaderAsset(initialize1);
			}
		}
		
	}
}
