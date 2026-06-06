using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;


namespace LegaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class JogadoresController : ControllerBase
    {
        private readonly AppDbContext _context;

        public JogadoresController(AppDbContext context)
        {
            _context = context;
        }


        [HttpGet]
        public async Task<ActionResult> GetJogadores()
        {
            var jogadores = await _context.Jogadores
                .Select(j => new
                {
                    j.JogadorId,
                    j.Nome,
                    j.NumeroCamisola,
                    j.EquipaId,
                    j.TorneioId

                }).ToListAsync();

            return Ok(jogadores);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult> GetJogador(int id)
        {
            var jogador = await _context.Jogadores
                .Where(j => j.JogadorId == id)
                .Select(j => new
                {
                    j.JogadorId,
                    j.Nome,
                    j.NumeroCamisola,
                    j.EquipaId,
                    j.TorneioId

                }).SingleOrDefaultAsync();

            if (jogador == null)
            {
                return NotFound("Jogador não encontrado.");
            }

            return Ok(jogador);
        }

        [HttpPost]
        public async Task<ActionResult> PostJogador([FromBody] Jogadores jogador)
        {

            _context.Jogadores.Add(jogador);
            await _context.SaveChangesAsync();

            return Ok(jogador);
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateJogador(int id, [FromBody] Jogadores jogador)
        {
            if (id != jogador.JogadorId)
            {
                return BadRequest("IDs não coincidem");
            }

            _context.Jogadores.Update(jogador);
            await _context.SaveChangesAsync();

            return Ok(jogador);
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteJogador(int id)
        {
            var jogador = await _context.Jogadores.SingleOrDefaultAsync(j => j.JogadorId == id);
            if (jogador == null)
            {
               return NotFound("Jogador não encontrado");
            }

            _context.Jogadores.Remove(jogador);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Jogador removido.", id = id });
        }
    }
}
