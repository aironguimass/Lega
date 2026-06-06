using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Icone
{
    public int IconeId { get; set; }

    public string Nome { get; set; } = null!;

    public string CaminhoAsset { get; set; } = null!;

    public virtual ICollection<Torneio> Torneios { get; set; } = new List<Torneio>();
}
