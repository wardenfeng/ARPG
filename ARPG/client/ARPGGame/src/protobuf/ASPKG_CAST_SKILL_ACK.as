package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import protobuf.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ASPKG_CAST_SKILL_ACK extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RESULT:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("protobuf.ASPKG_CAST_SKILL_ACK.result", "result", (1 << 3) | com.netease.protobuf.WireType.VARINT, protobuf.ASPKG_CAST_SKILL_ACK.E_CAST_SKILL_RESULT);

		public var result:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.result);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_ACK.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
