using System;
using System.Collections.Generic;
using LegaAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace LegaAPI.Data;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Equipa> Equipas { get; set; }

    public virtual DbSet<GolsDoJogo> GolsDoJogos { get; set; }

    public virtual DbSet<Icone> Icones { get; set; }

    public virtual DbSet<Jogadores> Jogadores { get; set; }

    public virtual DbSet<Jogo> Jogos { get; set; }

    public virtual DbSet<Torneio> Torneios { get; set; }

    public virtual DbSet<TorneioEquipa> TorneioEquipas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=LegaGestaoTorneiosDB;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Equipa>(entity =>
        {
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Usuario).WithMany(p => p.Equipas)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Equipas_Usuarios");
        });

        modelBuilder.Entity<GolsDoJogo>(entity =>
        {
            entity.HasKey(e => e.GolId);

            entity.ToTable("GolsDoJogo");

            entity.HasOne(d => d.Jogador).WithMany(p => p.GolsDoJogos)
                .HasForeignKey(d => d.JogadorId)
                .HasConstraintName("FK_GolsDoJogo_Jogadores");

            entity.HasOne(d => d.Jogo).WithMany(p => p.GolsDoJogos)
                .HasForeignKey(d => d.JogoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GolsDoJogo_Jogos");
        });

        modelBuilder.Entity<Icone>(entity =>
        {
            entity.Property(e => e.CaminhoAsset)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Nome)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Jogadores>(entity =>
        {
            entity.HasKey(e => e.JogadorId);

            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Equipa).WithMany(p => p.Jogadores)
                .HasForeignKey(d => d.EquipaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Jogadores_Equipas");

            entity.HasOne(d => d.Torneio).WithMany(p => p.Jogadores)
                .HasForeignKey(d => d.TorneioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Jogadores_Torneios");
        });

        modelBuilder.Entity<Jogo>(entity =>
        {
            entity.Property(e => e.EquipaAId).HasColumnName("EquipaA_Id");
            entity.Property(e => e.EquipaBId).HasColumnName("EquipaB_Id");

            entity.HasOne(d => d.EquipaA).WithMany(p => p.JogoEquipaAs)
                .HasForeignKey(d => d.EquipaAId)
                .HasConstraintName("FK_Jogos_EquipaA");

            entity.HasOne(d => d.EquipaB).WithMany(p => p.JogoEquipaBs)
                .HasForeignKey(d => d.EquipaBId)
                .HasConstraintName("FK_Jogos_EquipaB");

            entity.HasOne(d => d.JogoSeguinte).WithMany(p => p.InverseJogoSeguinte)
                .HasForeignKey(d => d.JogoSeguinteId)
                .HasConstraintName("FK_Jogos_JogoSeguinte");

            entity.HasOne(d => d.Torneio).WithMany(p => p.Jogos)
                .HasForeignKey(d => d.TorneioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Jogos_Torneios");

            entity.HasOne(d => d.Vencedor).WithMany(p => p.JogoVencedors)
                .HasForeignKey(d => d.VencedorId)
                .HasConstraintName("FK_Jogos_Vencedor");
        });

        modelBuilder.Entity<Torneio>(entity =>
        {
            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DataFim).HasColumnType("datetime");
            entity.Property(e => e.DataInicio).HasColumnType("datetime");
            entity.Property(e => e.Descricao)
                .HasMaxLength(500)
                .IsUnicode(false);
            entity.Property(e => e.Nome)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("EmConstrucao");

            entity.HasOne(d => d.EquipaCampea).WithMany(p => p.Torneios)
                .HasForeignKey(d => d.EquipaCampeaId)
                .HasConstraintName("FK_Torneios_EquipaCampea");

            entity.HasOne(d => d.Icone).WithMany(p => p.Torneios)
                .HasForeignKey(d => d.IconeId)
                .HasConstraintName("FK_Torneios_Icones");

            entity.HasOne(d => d.Usuario).WithMany(p => p.Torneios)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Torneios_Usuarios");
        });

        modelBuilder.Entity<TorneioEquipa>(entity =>
        {
            entity.HasKey(e => new { e.TorneioId, e.EquipaId });

            entity.ToTable("Torneio_Equipas");

            entity.Property(e => e.Gm).HasColumnName("GM");
            entity.Property(e => e.Gs).HasColumnName("GS");
            entity.Property(e => e.Pj).HasColumnName("PJ");
            entity.Property(e => e.Sg).HasColumnName("SG");
            entity.Property(e => e.StatusNaCompeticao)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasDefaultValue("Ativa");

            entity.HasOne(d => d.Equipa).WithMany(p => p.TorneioEquipas)
                .HasForeignKey(d => d.EquipaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TorneioEquipas_Equipas");

            entity.HasOne(d => d.Torneio).WithMany(p => p.TorneioEquipas)
                .HasForeignKey(d => d.TorneioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TorneioEquipas_Torneios");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasIndex(e => e.Email, "UQ_Usuarios_Email").IsUnique();

            entity.Property(e => e.DataCriacao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.PalavraPasseHash)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
