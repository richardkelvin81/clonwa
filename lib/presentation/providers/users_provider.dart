import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:myapp/data/models/chat.dart';
import 'package:myapp/data/models/message.dart';
import 'package:myapp/data/models/user.dart';
import 'package:myapp/data/repositories/chat_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/users_repository.dart';

/// Estado del chat
class UsersState {
  final List<Usuario> users;
 

  const UsersState({
    this.users = const [],
   
  });

  UsersState copyWith({
    List<Usuario>? users,
  
  }) {
    return UsersState(
      users: users ?? this.users,
     
    );
  }
}

/// Notifier para manejar la lógica del chat
class UsersNotifier extends StateNotifier<UsersState> {
  final UsersRepository _usersRepository;




 UsersNotifier({
    required UsersRepository usersRepository,
 
  })  : _usersRepository = usersRepository,
      
        super(const UsersState()) {
          getUsers();
  
  }




  /// Obtener chats
  void getUsers() {
    _usersRepository.getUsers().listen((misusers) {
      state = state.copyWith(users: misusers);
    });
  }


}

/// Provider global
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier(usersRepository: UsersRepository());
});
