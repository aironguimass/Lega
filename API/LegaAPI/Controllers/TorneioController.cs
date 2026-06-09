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
                    t.DataFim,
                    TotalEquipas = _context.TorneioEquipas.Count( te => te.TorneioId == t.TorneioId )
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
                                        TotalEquipas = _context.TorneioEquipas.Count(te => te.TorneioId == t.TorneioId)

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
            torneio.Status = "Ativo";
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

            // 1. Busca o registo original na base de dados
            var torneioExistente = await _context.Torneios.FindAsync(id);

            if (torneioExistente == null)
            {
                return NotFound("Torneio não encontrado.");
            }

            // 2. Atualiza apenas os campos que o utilizador pode editar
            torneioExistente.Nome = torneio.Nome;
            torneioExistente.Descricao = torneio.Descricao;
            torneioExistente.Status = torneio.Status; // "Ativo" ou "Finalizado"
            torneioExistente.DataInicio = torneio.DataInicio;
            torneioExistente.DataFim = torneio.DataFim;
            torneioExistente.IconeId = torneio.IconeId;
            torneioExistente.EquipaCampeaId = torneio.EquipaCampeaId;

            // 3. Guarda as alterações
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return BadRequest("Erro ao atualizar o torneio.");
            }

            return Ok(torneioExistente);
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

