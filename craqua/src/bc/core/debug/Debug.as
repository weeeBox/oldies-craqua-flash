package bc.core.debug
{
	/**
	 * @author weee
	 */
	public class Debug
	{
		public static function assert(condition : Boolean, message : String = null) : void
		{
			//#if DEBUG
			if (!condition)
			{
				throw new Error("ASSERT" + (message != null ? (": " + message) : ""));	
			}
			//#endif
		}
	}
}
