using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Torneio
{
    public int TorneioId { get; set; }

    public int UsuarioId { get; set; }

    public int? IconeId { get; set; }

    public int? EquipaCampeaId { get; set; }

    public string Nome { get; set; } = null!;

    public string? Descricao { get; set; }

    public string Status { get; set; } = null!;

    public bool Excluido { get; set; }

    public DateTime DataCriacao { get; set; }

    public DateTime? DataInicio { get; set; }

    public DateTime? DataFim { get; set; }

    public virtual Equipa? EquipaCampea { get; set; }

    public virtual Icone? Icone { get; set; }

    public virtual ICollection<Jogadores> Jogadores { get; set; } = new List<Jogadores>();

    public virtual ICollection<Jogo> Jogos { get; set; } = new List<Jogo>();

    public virtual ICollection<TorneioEquipa> TorneioEquipas { get; set; } = new List<TorneioEquipa>();

    public virtual Usuario Usuario { get; set; } = null!;
}
