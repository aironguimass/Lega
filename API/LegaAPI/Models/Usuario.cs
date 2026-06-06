using System;
using System.Collections.Generic;

namespace LegaAPI.Models;

public partial class Usuario
{
    public int UsuarioId { get; set; }

    public string Nome { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string PalavraPasseHash { get; set; } = null!;

    public DateTime DataCriacao { get; set; }

    public virtual ICollection<Equipa> Equipas { get; set; } = new List<Equipa>();

    public virtual ICollection<Torneio> Torneios { get; set; } = new List<Torneio>();
  
}
