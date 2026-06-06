using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Jogadores
{
    public int JogadorId { get; set; }

    public int EquipaId { get; set; }

    public int TorneioId { get; set; }

    public string Nome { get; set; } = null!;

    public int? NumeroCamisola { get; set; }

    public virtual Equipa Equipa { get; set; } = null!;

    public virtual ICollection<GolsDoJogo> GolsDoJogos { get; set; } = new List<GolsDoJogo>();

    public virtual Torneio Torneio { get; set; } = null!;
}
