/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-09 18:48:17
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-09 18:56:09
 */
import 'package:bloc/bloc.dart';
import 'package:codind/entity/entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'mind_map_event.dart';
part 'mind_map_state.dart';

class MindMapBloc extends Bloc<MindMapEvent, MindMapState> {
  var uuid = const Uuid();
  MindMapBloc() : super(const MindMapState()) {
    on<InitialMindMapEvent>(_fetchToState);
  }

  Future<void> _fetchToState(
      InitialMindMapEvent event, Emitter<MindMapState> emit) async {
    MindMapNode mindMapNode =
        MindMapNode(name: "root", id: uuid.v4(), properties: null);
    emit(state.copyWith(MindMapStatus.addNode, [mindMapNode]));
    debugPrint(
        "[debug MindMapBloc: mindMapNodes length]: ${state.mindMapNodes.length}");
  }
}
