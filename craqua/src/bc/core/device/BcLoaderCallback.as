package bc.core.device
{
	/**
	 * @author weee
	 */
	public interface BcLoaderCallback
	{
		function onResourceLoaded(loader:BcLoader):void;
		function onDescriptionLoaded(loader:BcLoader):void;
	}
}
