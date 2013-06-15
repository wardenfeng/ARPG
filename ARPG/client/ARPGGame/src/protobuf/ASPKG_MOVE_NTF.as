package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ASPKG_MOVE_NTF extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_MOVE_NTF.playerId", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playerId:int;

		/**
		 *  @private
		 */
		public static const MAPX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_MOVE_NTF.mapX", "mapX", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapX:int;

		/**
		 *  @private
		 */
		public static const MAPY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_MOVE_NTF.mapY", "mapY", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapY:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.playerId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapX);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapY);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerId$count:uint = 0;
			var mapX$count:uint = 0;
			var mapY$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_MOVE_NTF.playerId cannot be set twice.');
					}
					++playerId$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (mapX$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_MOVE_NTF.mapX cannot be set twice.');
					}
					++mapX$count;
					this.mapX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (mapY$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_MOVE_NTF.mapY cannot be set twice.');
					}
					++mapY$count;
					this.mapY = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
