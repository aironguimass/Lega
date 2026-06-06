using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]

    public class EquipaController : ControllerBase
    {
        private readonly AppDbContext _context;

        public EquipaController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult> GetEquipas()
        {
            var equipas = await _context.Equipas
                .Select(e => new
                {
                    e.EquipaId,
                    e.UsuarioId,
                    e.Nome
                }).ToListAsync();

            return Ok(equipas);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult> GetEquipa(int id)
        {
            var equipa = await _context.Equipas
                .Where(e => e.EquipaId == id)
                .Select(e => new
                {
                    e.EquipaId,
                    e.UsuarioId,
                    e.Nome
                })
                .SingleOrDefaultAsync();

            if (equipa == null)
            {
                return NotFound("Equipa não encontrada.");
            }

            return Ok(equipa);
        }



        [HttpPost]
        public async Task<ActionResult<Equipa>> PostEquipa([FromBody] Equipa equipa)
        {
            _context.Equipas.Add(equipa);
            await _context.SaveChangesAsync();

            return Ok(equipa);
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateEquipa (int id, [FromBody] Equipa equipa)
        {
            if (id != equipa.EquipaId)
            {
                return BadRequest("IDs não coincidem");
            }
            _context.Equipas.Update(equipa);
            await _context.SaveChangesAsync();

            return Ok(equipa);
        }

        [HttpDelete("{id}")]
        public async Task <IActionResult> RemoveEquipa(int id)
        {
            var equipa = await _context.Equipas.SingleOrDefaultAsync
                (e => e.EquipaId == id);
            if (equipa == null)
            {
                return NotFound("Equipa não encontrada");
            }

            _context .Equipas.Remove(equipa);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Equipa removida." , id = id });
        }
    }
}
