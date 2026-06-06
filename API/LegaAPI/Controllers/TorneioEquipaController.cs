using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace LegaAPI.Controllers
{

    [Route("api/[Controller]")]
    [ApiController]


    public class TorneioEquipaController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TorneioEquipaController(AppDbContext context)
        {
            _context = context;
        }


        [HttpGet("Torneio/{torneioId}")] // Pesquisar todas as equipas inscritas num torneio
        public async Task<ActionResult> GetEquipasDoTorneio(int torneioId)
        {
            var inscricoes = await _context.TorneioEquipas
                .Where(te => te.TorneioId == torneioId)
                .Select(te => new
                {
                    te.TorneioId,
                    te.EquipaId,
        
                    NomeEquipa = te.Equipa.Nome,
                    UsuarioIdEquipa = te.Equipa.UsuarioId
                })
                .ToListAsync();

            return Ok(inscricoes);
        }




        [HttpPost("Inscrever")] //adiciona uma equipa no torneio
        public async Task<ActionResult<TorneioEquipa>> InscreverEquipa([FromBody] TorneioEquipa torneioEquipa)
        {
            _context.TorneioEquipas.Add(torneioEquipa);
            await _context.SaveChangesAsync();

            return Ok(torneioEquipa);
        }




        [HttpDelete("Remover/{torneioId}/{equipaId}")]
        public async Task<IActionResult> RemoverEquipa(int torneioId, int equipaId)
        {
            var inscricao = await _context.TorneioEquipas
                .SingleOrDefaultAsync(te => te.TorneioId == torneioId && te.EquipaId == equipaId);


            if (inscricao == null)
            {
                return NotFound("Inscrição não encontrada");
            }

            _context.TorneioEquipas.Remove(inscricao);
            await _context.SaveChangesAsync();


            return Ok(new { message = "Equipa removida!", torneioId = torneioId, equipaId = equipaId});

        }
    }
}
