import 'package:flutter/material.dart';
import 'package:pbl2/theme/colors.dart';

class Torneio {
  final int torneioId;
  final int usuarioId;
  final int? iconeId;
  final int? equipaCampeaId;
  final String nome;
  final String? descricao;
  final String status;
  final DateTime dataCriacao;
  final int totalEquipas;
  final Color? cor; // Adicionado
  final IconData? icone;

  Torneio({
    required this.torneioId,
    required this.usuarioId,
    this.iconeId,
    this.equipaCampeaId,
    required this.nome,
    this.descricao,
    required this.status,
    required this.dataCriacao,
    required this.totalEquipas,
    this.cor,
    this.icone,
  });

  Color get corStatus =>
      (status == 'Ativo') ? AppColors.statusActive : AppColors.statusFinished;

  factory Torneio.fromJson(Map<String, dynamic> json) {
    return Torneio(
      torneioId: json['torneioId'],
      usuarioId: json['usuarioId'],
      iconeId: json['iconeId'],
      equipaCampeaId: json['equipaCampeaId'],
      nome: json['nome'] ?? 'Sem nome',
      descricao: json['descricao'],
      status: json['status'],
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.parse(json['dataCriacao'])
          : DateTime.now(),
      totalEquipas: json['totalEquipas'] ?? 0,
      cor: null,
      icone: null,
    );
  }
}
