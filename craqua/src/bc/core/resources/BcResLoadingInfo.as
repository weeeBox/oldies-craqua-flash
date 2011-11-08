package bc.core.resources
{
	/**
	 * @author weee
	 */
	public class BcResLoadingInfo
	{
		public var filename : String;
		public var type : int;
		public var id : int;
		
		public function BcResLoadingInfo(filename : String, type : int, id : int)
		{
			this.filename = filename;
			this.type = type;
			this.id = id;
		}
	}
}
