using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Equipa
{
    public int EquipaId { get; set; }

    public int UsuarioId { get; set; }

    public string Nome { get; set; } = null!;

    public virtual ICollection<Jogadores> Jogadores { get; set; } = new List<Jogadores>();

    public virtual ICollection<Jogo> JogoEquipaAs { get; set; } = new List<Jogo>();

    public virtual ICollection<Jogo> JogoEquipaBs { get; set; } = new List<Jogo>();

    public virtual ICollection<Jogo> JogoVencedors { get; set; } = new List<Jogo>();

    public virtual ICollection<TorneioEquipa> TorneioEquipas { get; set; } = new List<TorneioEquipa>();

    public virtual ICollection<Torneio> Torneios { get; set; } = new List<Torneio>();

    public virtual Usuario Usuario { get; set; } = null!;
}
