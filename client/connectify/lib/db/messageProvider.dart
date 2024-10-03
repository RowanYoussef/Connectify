
import 'package:Connectify/core/message.dart';
import 'package:sqflite/sqflite.dart';

class Messageprovider {
  static Future<dynamic> insert(Message message, Database db) async{
    await db.insert(tableMessage, message.toMap());
  }
  
  static Future<Message?> getMessage(int id, Database db) async{
    List<Map<String, dynamic>> maps = await db.query(tableMessage, 
    columns:[columnId, columnSender, columnReceiver, columnReplied,
     columnTime, columnString, columnAttachment],
    where: '$columnId = ?',
    whereArgs: [id]
    ) as List<Map<String,dynamic>>;
    if (maps.length > 0){
      return Message.fromMap(maps.first);
    }
    return null;
  } 

  static Future<List<Message>> getMessagesOfChat(Database db, String sender,
   String receiver)async{
    List<Map<String, dynamic>> maps = await db.query(tableMessage, 
    columns:[columnId, columnSender, columnReceiver, columnReplied,
     columnTime, columnString, columnAttachment],
    where: '( $columnSender = ? AND $columnReceiver = ? ) OR ( $columnSender = ? AND $columnReceiver = ? )',
    whereArgs: [sender, receiver, receiver, sender],
    orderBy: '$columnTime ASC',
    ) as List<Map<String,dynamic>>;
    List<Message> res = [];
    for(Map<String, dynamic> map in maps){
      res.add(Message.fromMap(map));
    }

    return res;
  }

  static Future<int> update(Message message, Database db) async{
    return await db.update(tableMessage, message.toMap(),
    where: '$columnId = ?', whereArgs: [message.id]);
  }

  static delete(int id, Database db) async{
    return await db.delete(tableMessage, where: '$columnId = ?', whereArgs: [id]);
  }
}