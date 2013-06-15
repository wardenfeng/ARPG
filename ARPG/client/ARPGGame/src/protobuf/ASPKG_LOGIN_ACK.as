package protobuf {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import protobuf.ASPKG_LOGIN_ACK.E_LOGIN_RESULT;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class ASPKG_LOGIN_ACK extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RESULT:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("protobuf.ASPKG_LOGIN_ACK.result", "result", (1 << 3) | com.netease.protobuf.WireType.VARINT, protobuf.ASPKG_LOGIN_ACK.E_LOGIN_RESULT);

		public var result:int;

		/**
		 *  @private
		 */
		public static const USERNAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("protobuf.ASPKG_LOGIN_ACK.username", "username", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var username$field:String;

		public function clearUsername():void {
			username$field = null;
		}

		public function get hasUsername():Boolean {
			return username$field != null;
		}

		public function set username(value:String):void {
			username$field = value;
		}

		public function get username():String {
			return username$field;
		}

		/**
		 *  @private
		 */
		public static const MAPX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.mapX", "mapX", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapX$field:int;

		private var hasField$0:uint = 0;

		public function clearMapX():void {
			hasField$0 &= 0xfffffffe;
			mapX$field = new int();
		}

		public function get hasMapX():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set mapX(value:int):void {
			hasField$0 |= 0x1;
			mapX$field = value;
		}

		public function get mapX():int {
			return mapX$field;
		}

		/**
		 *  @private
		 */
		public static const MAPY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.mapY", "mapY", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapY$field:int;

		public function clearMapY():void {
			hasField$0 &= 0xfffffffd;
			mapY$field = new int();
		}

		public function get hasMapY():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set mapY(value:int):void {
			hasField$0 |= 0x2;
			mapY$field = value;
		}

		public function get mapY():int {
			return mapY$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYERID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.playerId", "playerId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var playerId$field:int;

		public function clearPlayerId():void {
			hasField$0 &= 0xfffffffb;
			playerId$field = new int();
		}

		public function get hasPlayerId():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set playerId(value:int):void {
			hasField$0 |= 0x4;
			playerId$field = value;
		}

		public function get playerId():int {
			return playerId$field;
		}

		/**
		 *  @private
		 */
		public static const CLOTHING:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("protobuf.ASPKG_LOGIN_ACK.clothing", "clothing", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var clothing$field:String;

		public function clearClothing():void {
			clothing$field = null;
		}

		public function get hasClothing():Boolean {
			return clothing$field != null;
		}

		public function set clothing(value:String):void {
			clothing$field = value;
		}

		public function get clothing():String {
			return clothing$field;
		}

		/**
		 *  @private
		 */
		public static const MAPID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.mapId", "mapId", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapId$field:int;

		public function clearMapId():void {
			hasField$0 &= 0xfffffff7;
			mapId$field = new int();
		}

		public function get hasMapId():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set mapId(value:int):void {
			hasField$0 |= 0x8;
			mapId$field = value;
		}

		public function get mapId():int {
			return mapId$field;
		}

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.HP", "hP", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var HP$field:int;

		public function clearHP():void {
			hasField$0 &= 0xffffffef;
			HP$field = new int();
		}

		public function get hasHP():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set hP(value:int):void {
			hasField$0 |= 0x10;
			HP$field = value;
		}

		public function get hP():int {
			return HP$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("protobuf.ASPKG_LOGIN_ACK.MP", "mP", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var MP$field:int;

		public function clearMP():void {
			hasField$0 &= 0xffffffdf;
			MP$field = new int();
		}

		public function get hasMP():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set mP(value:int):void {
			hasField$0 |= 0x20;
			MP$field = value;
		}

		public function get mP():int {
			return MP$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.result);
			if (hasUsername) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, username$field);
			}
			if (hasMapX) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapX$field);
			}
			if (hasMapY) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapY$field);
			}
			if (hasPlayerId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, playerId$field);
			}
			if (hasClothing) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, clothing$field);
			}
			if (hasMapId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapId$field);
			}
			if (hasHP) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, HP$field);
			}
			if (hasMP) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, MP$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var username$count:uint = 0;
			var mapX$count:uint = 0;
			var mapY$count:uint = 0;
			var playerId$count:uint = 0;
			var clothing$count:uint = 0;
			var mapId$count:uint = 0;
			var HP$count:uint = 0;
			var MP$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (username$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.username cannot be set twice.');
					}
					++username$count;
					this.username = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (mapX$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.mapX cannot be set twice.');
					}
					++mapX$count;
					this.mapX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (mapY$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.mapY cannot be set twice.');
					}
					++mapY$count;
					this.mapY = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.playerId cannot be set twice.');
					}
					++playerId$count;
					this.playerId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (clothing$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.clothing cannot be set twice.');
					}
					++clothing$count;
					this.clothing = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					if (mapId$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.mapId cannot be set twice.');
					}
					++mapId$count;
					this.mapId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (HP$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.hP cannot be set twice.');
					}
					++HP$count;
					this.hP = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (MP$count != 0) {
						throw new flash.errors.IOError('Bad data format: ASPKG_LOGIN_ACK.mP cannot be set twice.');
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
