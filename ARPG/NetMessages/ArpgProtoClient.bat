ProtocolCoderAs ARPGProto.xml --client
move /Y ARPGProto.as ..\client\ARPGGame\src\
del /s/q ..\client\ARPGGame\src\protobuf\ 
xcopy /E /Y protobuf ..\client\ARPGGame\src\protobuf\
del initializer.as.inc
rd protobuf /s /q
pause
