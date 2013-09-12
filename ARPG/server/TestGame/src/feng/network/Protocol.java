package feng.network;

import java.nio.ByteBuffer;

import protobuf.ARPGProto.ASPKG_CAST_SKILL_REQ;
import protobuf.ARPGProto.ASPKG_CHAT_REQ;
import protobuf.ARPGProto.ASPKG_LOGIN_REQ;
import protobuf.ARPGProto.ASPKG_MOVE_REQ;

import com.google.protobuf.InvalidProtocolBufferException;
import com.googlecode.protobuf.format.JsonFormat;

import feng.MsgProcessor;

/**
 * 
 * @author warden_feng 2013-2-20
 */
public class Protocol
{
	static public final int ASID_LOGIN_REQ = 1;
	static public final int ASID_LOGIN_ACK = 2;
	static public final int ASID_MOVE_REQ = 3;
	static public final int ASID_MOVE_ACK = 4;
	static public final int ASID_MOVE_NTF = 5;
	static public final int ASID_ADD_PLAYER_NTF = 6;
	static public final int ASID_REMOVE_PLAYER_NTF = 7;
	static public final int ASID_CAST_SKILL_REQ = 8;
	static public final int ASID_CAST_SKILL_ACK = 9;
	static public final int ASID_CAST_SKILL_NTF = 10;
	static public final int ASID_HP_UPDATE_NTF = 11;
	static public final int ASID_MP_UPDATE_NTF = 12;
	public static final int ASID_ADD_MONSTER_NTF = 13;
	public static final int ASID_CHAT_REQ = 14;
	public static final int ASID_CHAT_Ntf = 15;
	

	public static void Decode(int MsgID, ByteBuffer byteBuffer, MsgProcessor proc)
			throws InvalidProtocolBufferException
	{
		switch (MsgID)
		{
		case ASID_LOGIN_REQ:
			ASPKG_LOGIN_REQ loginReq = ASPKG_LOGIN_REQ.parseFrom(byteBuffer.array());
			System.out.println(JsonFormat.printToString(loginReq));
			proc.OnRecvLoginReq(loginReq);
			break;
		case ASID_MOVE_REQ:
			ASPKG_MOVE_REQ walkReq = ASPKG_MOVE_REQ.parseFrom(byteBuffer.array());
			proc.OnRecvWalkReq(walkReq);
			break;
		case ASID_CAST_SKILL_REQ:
			ASPKG_CAST_SKILL_REQ castSkillReq = ASPKG_CAST_SKILL_REQ.parseFrom(byteBuffer.array());
			proc.OnRecvCastSkillReq(castSkillReq);
			break;
		case ASID_CHAT_REQ:
			ASPKG_CHAT_REQ chatReq = ASPKG_CHAT_REQ.parseFrom(byteBuffer.array());
			proc.OnRecvChatReq(chatReq);
			break;
		default:
			System.out.println("收到陌生协议号：" + MsgID);
			break;
		}
	}
}
