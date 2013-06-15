ProtocolCoderAs ARPGProto.xml --client
move /Y ARPGProto.as F:\fengWorkspace\as\webgobang\ARPGGame\src\
del /s/q F:\fengWorkspace\as\webgobang\ARPGGame\src\protobuf\ 
xcopy /E /Y protobuf F:\fengWorkspace\as\webgobang\ARPGGame\src\protobuf\
del initializer.as.inc
rd protobuf /s /q
pause
