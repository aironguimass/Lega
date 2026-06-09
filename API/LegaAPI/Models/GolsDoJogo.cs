using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class GolsDoJogo
{
    public int GolId { get; set; }

    public int JogoId { get; set; }

    public int? JogadorId { get; set; }

    public virtual Jogadores? Jogador { get; set; }

    public virtual Jogo Jogo { get; set; } = null!;
}
