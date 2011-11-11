package bc.core.timer
{
	import bc.core.debug.BcDebug;
	/**
	 * @author weee
	 */
	public class BcTimer
	{
		private static var timerManager : BcTimerManager;

        public var listener : BcTimerListener;

        public var desiredInterval : Number;
        public var lastFired : Number;

        private var started : Boolean;

        public function isTimerStarted() : Boolean
        {
            return started;
        }

        public function startTimer() : void
        {
            started = true;
            timerManager.registerTimer(this);
        }

        public function stopTimer() : void
        {
            started = false;
            timerManager.deregisterTimer(this);
        }

        public function onTimer() : void
        {
            // Do nothing by default
        }

        public function setTimerInterval(interval : Number) : void
        {
            desiredInterval = interval;
        }

        public function internalUpdate() : void
		{
			if (listener == null)
			{
                onTimer();
			}
            else
            {
                listener.onTimer();
            }
        }

        public static function setTimerManager(manager : BcTimerManager) : void
        {            
            BcDebug.assert(timerManager == null);
            timerManager = manager;
        }
	}
}
