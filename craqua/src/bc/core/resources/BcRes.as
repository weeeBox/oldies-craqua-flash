package bc.core.resources
{
	/**
	 * @author weee
	 */
	public class BcRes
	{
		private var info : BcResLoadingInfo;
		
		public function BcRes(info : BcResLoadingInfo)
		{
			this.info = info;
		}
		
		public function unload() : void
		{
			
		}
		
		public function getInfo() : BcResLoadingInfo
		{
			return info;
		}
	}
}
