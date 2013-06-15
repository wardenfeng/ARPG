package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import protobuf.E_ATTACK_TYPE;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ASPKG_CAST_SKILL_NTF extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PLAYERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_CAST_SKILL_NTF.playerId", "playerId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playerId:int;

		/**
		 *  @private
		 */
		public static const SKILLID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_CAST_SKILL_NTF.skillId", "skillId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("protobuf.ASPKG_CAST_SKILL_NTF.type", "type", (3 << 3) | com.netease.protobuf.WireType.VARINT, protobuf.E_ATTACK_TYPE);

		public var type:int;

		/**
		 *  @private
		 */
		public static const TARGETID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_CAST_SKILL_NTF.targetId", "targetId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var targetId$field:int;

		private var hasField$0:uint = 0;

		public function clearTargetId():void {
			hasField$0 &= 0xfffffffe;
			targetId$field = new int();
		}

		public function get hasTargetId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set targetId(value:int):void {
			hasField$0 |= 0x1;
			targetId$field = value;
		}

		public function get targetId():int {
			return targetId$field;
		}

		/**
		 *  @private
		 */
		public static const MAPX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_CAST_SKILL_NTF.mapX", "mapX", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapX$field:int;

		public function clearMapX():void {
			hasField$0 &= 0xfffffffd;
			mapX$field = new int();
		}

		public function get hasMapX():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set mapX(value:int):void {
			hasField$0 |= 0x2;
			mapX$field = value;
		}

		public function get mapX():int {
			return mapX$field;
		}

		/**
		 *  @private
		 */
		public static const MAPY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_CAST_SKILL_NTF.mapY", "mapY", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapY$field:int;

		public function clearMapY():void {
			hasField$0 &= 0xfffffffb;
			mapY$field = new int();
		}

		public function get hasMapY():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set mapY(value:int):void {
			hasField$0 |= 0x4;
			mapY$field = value;
		}

		public function get mapY():int {
			return mapY$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.playerId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			if (hasTargetId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, targetId$field);
			}
			if (hasMapX) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapX$field);
			}
			if (hasMapY) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapY$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerId$count:uint = 0;
			var skillId$count:uint = 0;
			var type$count:uint = 0;
			var targetId$count:uint = 0;
			var mapX$count:uint = 0;
			var mapY$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.playerId cannot be set twice.');
					}
					++playerId$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (skillId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.skillId cannot be set twice.');
					}
					++skillId$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 4:
					if (targetId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.targetId cannot be set twice.');
					}
					++targetId$count;
					this.targetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (mapX$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.mapX cannot be set twice.');
					}
					++mapX$count;
					this.mapX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (mapY$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_CAST_SKILL_NTF.mapY cannot be set twice.');
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
