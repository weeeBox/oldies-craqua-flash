package bc.core.resources
{
	/**
	 * @author weee
	 */
	public interface BcResLoadingListener
	{
		function resourceLoaded(info : BcResLoadingInfo) : void;
		function resourcesLoaded() : void;		 
	}
}
