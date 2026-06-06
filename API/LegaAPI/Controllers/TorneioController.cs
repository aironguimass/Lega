using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]


    public class TorneioController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TorneioController(AppDbContext context)
        {
            _context = context;
        }


        [HttpGet]
        public async Task<ActionResult> GetTorneios()
        {
            var torneios = await _context.Torneios
                .Where(t => !t.Excluido)
                .Select(t => new
                {
                    t.TorneioId,
                    t.UsuarioId,
                    t.IconeId,
                    t.EquipaCampeaId,
                    t.Nome,
                    t.Descricao,
                    t.Status,
                    t.DataCriacao,
                    t.DataInicio,
                    t.DataFim
                }).ToListAsync();

            return Ok(torneios);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult> GetTorneio(int id)
        {
            var torneio = await _context.Torneios
                .Where(t => t.TorneioId == id)
                .Select(t => new
                {
                    t.TorneioId,
                    t.UsuarioId,
                    t.IconeId,
                    t.EquipaCampeaId,
                    t.Nome,
                    t.Descricao,
                    t.Status,
                    t.DataCriacao,
                    t.DataInicio,
                    t.DataFim
                })
                .SingleOrDefaultAsync(); // Trocado FindAsync por SingleOrDefaultAsync para manter o padrão

            if (torneio == null)
            {
                return NotFound("Torneio não encontrado.");
            }
            return Ok(torneio);
        }

        [HttpPost] //adiciona um novo usuario
        public async Task<ActionResult<Torneio>> PostTorneio([FromBody] Torneio torneio)
        {
            torneio.DataCriacao = DateTime.Now;
            torneio.Status = "Preparacao";
            torneio.Excluido = false;



            _context.Torneios.Add(torneio);
            await _context.SaveChangesAsync();

            return Ok(torneio);
        }




        [HttpPut("{id}")]
 public async Task<IActionResult> PutTorneio(int id, [FromBody] Torneio torneio)
        {
            if (id != torneio.TorneioId)
            {
                return BadRequest("IDs não coincidem");
            }
            _context.Torneios.Update(torneio);
            await _context.SaveChangesAsync();
            return Ok(torneio);
        }


        [HttpDelete("{id}")]
        public async Task <IActionResult> DeleteTorneio(int id)
        {
            var torneio = await _context.Torneios.SingleOrDefaultAsync(t => t.TorneioId == id);

            if (torneio == null)
            {
                return NotFound("Torneio não encontrado.");
            }
            torneio.Excluido = true;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Torneio removido.", id = id });

        }
    }
}

