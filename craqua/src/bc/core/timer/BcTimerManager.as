package bc.core.timer
{
	/**
	 * @author weee
	 */
	public interface BcTimerManager
    {
        function registerTimer(timer : BcTimer) : void;
        function deregisterTimer(timer : BcTimer) : void;        
    }
}
