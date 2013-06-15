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
	public dynamic final class ADD_PLAYER extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ADD_PLAYER.playerId", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playerId:int;

		/**
		 *  @private
		 */
		public static const MAPX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ADD_PLAYER.mapX", "mapX", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapX:int;

		/**
		 *  @private
		 */
		public static const MAPY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ADD_PLAYER.mapY", "mapY", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapY:int;

		/**
		 *  @private
		 */
		public static const USERNAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("protobuf.ADD_PLAYER.username", "username", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var username:String;

		/**
		 *  @private
		 */
		public static const CLOTHING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("protobuf.ADD_PLAYER.clothing", "clothing", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var clothing:String;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ADD_PLAYER.HP", "hP", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var hP:int;

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ADD_PLAYER.MP", "mP", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mP:int;

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
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.username);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.clothing);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.hP);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mP);
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
			var username$count:uint = 0;
			var clothing$count:uint = 0;
			var HP$count:uint = 0;
			var MP$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.playerId cannot be set twice.');
					}
					++playerId$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (mapX$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.mapX cannot be set twice.');
					}
					++mapX$count;
					this.mapX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (mapY$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.mapY cannot be set twice.');
					}
					++mapY$count;
					this.mapY = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (username$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.username cannot be set twice.');
					}
					++username$count;
					this.username = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (clothing$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.clothing cannot be set twice.');
					}
					++clothing$count;
					this.clothing = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (HP$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.hP cannot be set twice.');
					}
					++HP$count;
					this.hP = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (MP$count != 0) {
						throw new flash.errors.IOError('Bad data format: ADD_PLAYER.mP cannot be set twice.');
					}
					++MP$count;
					this.mP = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
