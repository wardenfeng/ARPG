package
{
	import flash.utils.Dictionary;

	/**
	 * 标记那些函数被调用，已经调用次数 
	 */	
	public function functionMarkTrace(fileName : String, functionName : String) : void
	{
		if (MyCC.funcMarkDic[fileName] == null)
		{
			MyCC.funcMarkDic[fileName] = new Dictionary();
		}
		var fileNameDic : Dictionary = MyCC.funcMarkDic[fileName];
		if (fileNameDic[functionName] == null)
		{
			fileNameDic[functionName] = 0;
		}
		fileNameDic[functionName]++;
	}
}