using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly AppDbContext _context;
        public UsuarioController(AppDbContext context)
        {
            _context = context; 
        }

        [HttpGet] //pesquisar todos os usuarios
        public async Task<ActionResult> GetUsuarios()
        {
           var usuarios =  await _context.Usuarios
                .Select(u => new
            {
                u.UsuarioId,
                u.Nome,
                u.Email,
                u.DataCriacao,
            })
                .ToListAsync();

            return Ok(usuarios);
        }


        [HttpGet("{id}")] // pesquisar um usuario por id
        public async Task<ActionResult> GetUsuario(int id)
        {
            var usuario = await _context.Usuarios
                .Where(u => u.UsuarioId == id)
                .Select(u => new
                {
                    u.UsuarioId,
                    u.Nome,
                    u.Email,
                    u.DataCriacao
                })
                .FirstOrDefaultAsync();

            if (usuario == null)
            {
                return NotFound("Utilizador não encontrado");
            }
            return Ok(usuario);
        }


        [HttpPost] //adiciona um novo usuario
        public async Task<ActionResult<Usuario>> PostUsuario([FromBody] Usuario usuario)
        {

            var existe = await _context.Usuarios.AnyAsync(u => u.Email == usuario.Email);
            if (existe)
            {
                return BadRequest("Email já existe.");
            }

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            return Ok(usuario);
        }


        [HttpPut("{id}")]

        public async Task<IActionResult> PutUsuario(int id, [FromBody] Usuario usuario)
        {
            if (id != usuario.UsuarioId) //verificacao se o Id da rota é igual o ID do utilizador
            {
                return BadRequest("IDs não coincidem");
            }
            _context.Usuarios.Update(usuario);
            await _context.SaveChangesAsync();

            return Ok(usuario);
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuario(int id)
        {
            var usuario = await _context.Usuarios.FindAsync(id);

            if (usuario == null)
            {
                return NotFound("Usuário não encontrado.");
            }

            _context.Usuarios.Remove(usuario);
            await _context.SaveChangesAsync();


            return Ok(new {message =  "Usuário removido!", id= id });

        }
    }
}

