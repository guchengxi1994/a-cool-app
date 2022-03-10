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
import 'package:codind/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;

part 'mind_map_event.dart';
part 'mind_map_state.dart';

class MindMapBloc extends Bloc<MindMapEvent, MindMapState> {
  MindMapBloc() : super(const MindMapState()) {
    on<InitialMindMapEvent>(_fetchToState);
    on<AddMindMapEventSimple>(_addNodeSimple);
  }

  Future<void> _fetchToState(
      InitialMindMapEvent event, Emitter<MindMapState> emit) async {
    emit(state.copyWith(MindMapStatus.initial, [], [], []));
    debugPrint(
        "[debug MindMapBloc]: mindMapNodes length ${state.mindMapNodes.length}");
  }

  Future<void> _addNodeSimple(
      AddMindMapEventSimple event, Emitter<MindMapState> emit) async {
    List<MindMapNode> nodes = state.mindMapNodes..add(event.mindMapNode);
    var widgets = state.widgets..add(event.nodeWidget);
    var globalkeys = state.globalKeys..add(event.globalKey);
    emit(state.copyWith(MindMapStatus.addNode, nodes, widgets, globalkeys));
    debugPrint(
        "[debug MindMapBloc]: mindMapNodes length ${state.widgets.length}");
  }
}
