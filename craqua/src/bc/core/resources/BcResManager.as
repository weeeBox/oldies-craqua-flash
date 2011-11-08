package bc.core.resources
{
	import bc.core.timer.BcTimer;
	import bc.core.debug.Debug;
	/**
	 * @author weee
	 */
	public class BcResManager extends BcTimer
	{
		private const LOADING_TIME_INTERVAL : Number = 1.0 / 20.0;
		
		private var resources : Vector.<BcRes>;
		private var loadQueue : Vector.<BcResLoadingInfo>;
		private var loadedCount : int;
		private var loadQueueSize : int;
		
		private var listener : BcResLoadingListener;
		
		public function BcResManager(resCount : int)
		{
			resources = new Vector.<BcRes>(resCount, true);
			loadQueue = new Vector.<BcResLoadingInfo>(resCount, true);
			setTimerInterval(LOADING_TIME_INTERVAL);			
		}
		
		public function initLoading() : void
		{
			loadedCount = 0;
			loadQueueSize = 0;
			stopTimer();	
		}		
		
		public function startLoading() : void
		{
			startTimer();
		}
		
		public function queueResource(info : BcResLoadingInfo) : void
		{			
			Debug.assert(resources[info.id] != null, "Resource already loaded: " + info.filename);
			loadQueue[loadQueueSize] = info;
			loadQueueSize++;	
		}
		
		public function loadImmediately() : void
		{			
			for (var i : int = 0; i < loadQueueSize; ++i)
			{
				var info : BcResLoadingInfo = loadQueue[i];
				var resource : BcRes = loadResource(info);
				Debug.assert(resource != null, "Unable to load resource: " + info.filename);
				resources[info.id] = resource;
				loadedCount++;	
			}
		}	
		
		public override function onTimer() : void
		{
			var info : BcResLoadingInfo = loadQueue[loadedCount];
			var resource : BcRes = loadResource(info);
			Debug.assert(resource != null, "Unable to load resource: " + info.filename);
			resources[info.id] = resource;
			loadedCount++;

			if (listener != null)
			{
                listener.resourceLoaded(info);
			}

			if (loadedCount == loadQueueSize)
            {
	            if (listener != null)
	            {
					listener.resourcesLoaded();
	            }
	            stopTimer();
            }            	
		}
		
		public function loadResource(info : BcResLoadingInfo) : BcRes
		{
			return null;
		}
		
		public function unloadResource(id : int) : void
		{
			var resource : BcRes = resources[id];			
			Debug.assert(resource != null, "Resource already unloaded: " + id);
			resource.unload();
			resources[id] = null;
		}
		
		public function getResouce(id : int) : BcRes
		{
			var res : BcRes = resources[id];
			Debug.assert(res != null, "Try to get not loaded resource: " + id);
			return res;
		}
		
		public function isResourceLoaded(id : int) : Boolean
		{
			return resources[id] != null;
		}
		
		public function isBusy() : Boolean
		{
			return isTimerStarted();
		}
		
		public function getPercentLoaded() : int
		{
			if (loadQueueSize == 0)
			{
				return 100;			
			}
			else
			{
				return ((100 * loadedCount) / loadQueueSize);
			}
		}
	}
}
