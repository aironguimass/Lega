using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]

    public class GolsDoJogoController : ControllerBase
    {
        private readonly AppDbContext _context;

        public GolsDoJogoController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult> GetGolsDoJogo()
        {
            var gols = await _context.GolsDoJogos
                .Select(g => new
                {
                    g.GolId,
                    g.JogoId,
                    g.JogadorId
                }).ToListAsync();

            return Ok(gols);
        }

        [HttpPost]
        public async Task<ActionResult<GolsDoJogo>> PostGolsDoJogo([FromBody] GolsDoJogo golsDoJogo)
        {
            _context.GolsDoJogos.Add(golsDoJogo);
            await _context.SaveChangesAsync();

            return Ok(golsDoJogo);

        }

        [HttpDelete("{id}")]
            public async Task<IActionResult> RemoveGolsDoJogo(int id)
        {
            var gol = await _context.GolsDoJogos.SingleOrDefaultAsync
                (e => e.GolId == id);

            if (gol == null)
            {
                return NotFound("Golo não encontrado");     
            }

        _context.GolsDoJogos.Remove(gol);  
            await _context.SaveChangesAsync();

            return Ok(new { message = "Gol removido", id = id } );
        }
    }
}
