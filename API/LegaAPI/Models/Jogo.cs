using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Jogo
{
    public int JogoId { get; set; }

    public int TorneioId { get; set; }

    public int Fase { get; set; }

    public int Slot { get; set; }

    public int? EquipaAId { get; set; }

    public int? EquipaBId { get; set; }

    public int? GolosA { get; set; }

    public int? GolosB { get; set; }

    public int? PenaltisA { get; set; }

    public int? PenaltisB { get; set; }

    public int? VencedorId { get; set; }

    public int? JogoSeguinteId { get; set; }

    public bool Isento { get; set; }

    public virtual Equipa? EquipaA { get; set; }

    public virtual Equipa? EquipaB { get; set; }

    public virtual ICollection<GolsDoJogo> GolsDoJogos { get; set; } = new List<GolsDoJogo>();

    public virtual ICollection<Jogo> InverseJogoSeguinte { get; set; } = new List<Jogo>();

    public virtual Jogo? JogoSeguinte { get; set; }

    public virtual Torneio Torneio { get; set; } = null!;

    public virtual Equipa? Vencedor { get; set; }
}
