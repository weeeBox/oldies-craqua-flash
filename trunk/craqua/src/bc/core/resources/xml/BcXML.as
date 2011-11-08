package bc.core.resources.xml
{
	import bc.core.resources.BcRes;
	import bc.core.resources.BcResLoadingInfo;

	/**
	 * @author weee
	 */
	public class BcXML extends BcRes
	{
		private var rootElement : BcXMLElement;
		
		public function BcXML(info : BcResLoadingInfo)
		{
			super(info);
		}
		
		public function getRootElement() : BcXMLElement
		{
			return rootElement;
		}
	}
}
