using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]

    public class JogoController : ControllerBase
    {
        private readonly AppDbContext _context;

        public JogoController(AppDbContext context)
        {
            _context = context;
        }



        [HttpGet]
        public async Task<ActionResult> GetJogos()
        {
            var jogos = await _context.Jogos
                .Select(j => new
                {
                    j.JogoId,
                    j.TorneioId,
                    j.Fase,
                    j.Slot,
                    j.EquipaAId,
                    j.EquipaBId,
                    j.GolosA,
                    j.GolosB,
                    j.PenaltisA,
                    j.PenaltisB,
                    j.VencedorId,
                    j.JogoSeguinteId,
                    j.Isento
                }).ToListAsync();

            return Ok(jogos);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult> GetJogo(int id)
        {
            var jogo = await _context.Jogos
                .Where(j => j.JogoId == id)
                .Select(j => new
                {
                    j.JogoId,
                    j.TorneioId,
                    j.Fase,
                    j.Slot,
                    j.EquipaAId,
                    j.EquipaBId,
                    j.GolosA,
                    j.GolosB,
                    j.PenaltisA,
                    j.PenaltisB,
                    j.VencedorId,
                    j.JogoSeguinteId,
                    j.Isento
                })
                .SingleOrDefaultAsync(); // Trocado FindAsync por SingleOrDefaultAsync para manter o padrão

            if (jogo == null)
                return NotFound("Jogo não encontrado");

            return Ok(jogo);
        }


        [HttpPost]
        public async Task<ActionResult> PostJogo([FromBody] Jogo jogo)
        {
            _context.Jogos.Add(jogo);
            await _context.SaveChangesAsync();

            return Ok(jogo);
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> PutJogo(int id, [FromBody] Jogo jogo)
        {
            if (id != jogo.JogoId)
                return BadRequest("IDs não coincidem");

            _context.Jogos.Update(jogo);
            await _context.SaveChangesAsync();

            return Ok(jogo);
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteJogo(int id)
        {
            var jogo = await _context.Jogos.SingleOrDefaultAsync(j => j.JogoId == id);

            if (jogo == null)
                return NotFound("Jogo não encontrado");

            _context.Jogos.Remove(jogo);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Jogo removido", id });
        }


    }
}
