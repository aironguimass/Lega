using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class TorneioEquipa
{
    public int TorneioId { get; set; }

    public int EquipaId { get; set; }

    public string StatusNaCompeticao { get; set; } = null!;

    public int Pj { get; set; }

    public int Gm { get; set; }

    public int Gs { get; set; }

    public int Sg { get; set; }

    public virtual Equipa Equipa { get; set; } = null!;

    public virtual Torneio Torneio { get; set; } = null!;
}
