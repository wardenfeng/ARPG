package communication
{

	public final class ProtoFactory
	{
		private static var slotProto:ARPGProto;

		public static function getSlotProto():ARPGProto
		{
			if (slotProto == null)
			{
				slotProto=new ARPGProto();
				slotProto.Init();
			}
			return slotProto;
		}
	}
}
