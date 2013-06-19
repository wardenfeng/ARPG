package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import protobuf.E_OBJECT_TYPE;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SKILL_HARM extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("protobuf.SKILL_HARM.type", "type", (1 << 3) | com.netease.protobuf.WireType.VARINT, protobuf.E_OBJECT_TYPE);

		public var type:int;

		/**
		 *  @private
		 */
		public static const TARGETID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.SKILL_HARM.targetId", "targetId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var targetId:int;

		/**
		 *  @private
		 */
		public static const HARMVALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.SKILL_HARM.harmValue", "harmValue", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var harmValue:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.targetId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.harmValue);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var targetId$count:uint = 0;
			var harmValue$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SKILL_HARM.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (targetId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SKILL_HARM.targetId cannot be set twice.');
					}
					++targetId$count;
					this.targetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (harmValue$count != 0) {
						throw new flash.errors.IOError('Bad data format: SKILL_HARM.harmValue cannot be set twice.');
					}
					++harmValue$count;
					this.harmValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
