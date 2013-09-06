package
{
	public function logger(info:*):void
	{
		var infoStr:String = "";
		if (info is Object)
		{
			infoStr = JSON.stringify(info);
		}
		else if(info is String)
		{
			infoStr = info;
		}
		else
		{
			infoStr = info.toString();
		}
		GlobalData.logFunc && GlobalData.logFunc(infoStr);
	}
}
