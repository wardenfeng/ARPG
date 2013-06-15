package
{
	import com.junkbyte.console.Cc;

	public function logger(info:*):void
	{
		if (info is Object)
		{
			info = JSON.stringify(info);
		}
		else
		{
			info = info.toString();
		}
		Cc.log(info);
	}
}
