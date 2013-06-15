package communication
{

	public class ServerAddress
	{

		public function ServerAddress()
		{
		}

		private var _host:String;

		private var _port:uint = 0;

		private var _policy:uint = 0;

		public function get host():String
		{
			return _host;
		}

		public function get port():uint
		{
			return _port;
		}

		public function get policy():uint
		{
			return _policy;
		}

		public function set host(host:String):void
		{
			_host = host;
		}

		public function set port(port:uint):void
		{
			_port = port;
		}

		public function set policy(policy:uint):void
		{
			_policy = policy;
		}

		public function toString():String
		{
			return "host:" + _host + ",port:" + _port + ",policy:" + _policy;
		}
	}
}
