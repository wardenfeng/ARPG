package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import protobuf.ADD_PLAYER;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ASPKG_ADD_PLAYER_NTF extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ADDPLAYER:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("protobuf.ASPKG_ADD_PLAYER_NTF.addPlayer", "addPlayer", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return protobuf.ADD_PLAYER; });

		[ArrayElementType("protobuf.ADD_PLAYER")]
		public var addPlayer:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var addPlayer$index:uint = 0; addPlayer$index < this.addPlayer.length; ++addPlayer$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.addPlayer[addPlayer$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.addPlayer.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new protobuf.ADD_PLAYER()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
