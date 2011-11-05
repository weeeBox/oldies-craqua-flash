package bc.game.init 
{
	import bc.core.device.BcAssetLoadingListener;
	import bc.core.device.BcDevice;
	import bc.core.device.BcEntryPoint;
	import bc.game.BcGamePreloader;
	import bc.game.asset.BcPreloaderAsset;

	/**
	 * @author Elias Ku
	 */
	
	public class BcPreloader extends BcEntryPoint implements BcAssetLoadingListener 
	{
		public function BcPreloader()
		{
			super();
			
			BcDevice.initialize(stage);
			
			if(BcDevice.impl)
				new BcPreloaderAsset(this);
		}
		
		public function onAssetLoadingCompleted():void
		{
			initialize();
		}
		
		private function initialize():void
		{
			new BcGamePreloader(this);
		}
		
	}
}
