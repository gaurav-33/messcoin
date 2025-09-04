// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 1;

  @override
  StudentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      rollNo: fields[2] as String,
      email: fields[3] as String,
      semester: fields[4] as int,
      isVerified: fields[5] as bool,
      isActive: fields[6] as bool,
      wallet: fields[7] as Wallet,
      roomNo: fields[8] as String,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      mess: fields[11] as Mess,
      imageUrl: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.rollNo)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.semester)
      ..writeByte(5)
      ..write(obj.isVerified)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.wallet)
      ..writeByte(8)
      ..write(obj.roomNo)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.mess)
      ..writeByte(12)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 2;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      totalCredit: fields[0] as num,
      loadedCredit: fields[1] as num,
      balance: fields[2] as num,
      leftOverCredit: fields[3] as num,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalCredit)
      ..writeByte(1)
      ..write(obj.loadedCredit)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.leftOverCredit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessAdapter extends TypeAdapter<Mess> {
  @override
  final int typeId = 3;

  @override
  Mess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mess(
      name: fields[0] as String,
      hostel: fields[1] as String,
      counters: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Mess obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.hostel)
      ..writeByte(2)
      ..write(obj.counters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
