package bc.game.asset 
{
	import bc.core.device.BcAsset;

	/**
	 * @author Elias Ku
	 */
	public class BcPreloaderAsset
	{
		[Embed(source="../../../../asset/preloader/main.ttf", fontName="main")]
        private var fntGROBOLD:Class;
        
        [Embed(source="../../../../asset/preloader/ui/bg_.jpg")]
		private static var img_ui_bg:Class;
		BcAsset.embedImage("ui_bg", img_ui_bg, false);
		
		[Embed(source="../../../../asset/preloader/data.xml", mimeType="application/octet-stream")]
		private static var xml_data:Class;
		BcAsset.embedXML("data", xml_data);
		        
		public function BcPreloaderAsset(callback:Function)
		{
			//BcAsset.load("../asset/preloader.xml", callback);
			callback();
		}
	}
}
