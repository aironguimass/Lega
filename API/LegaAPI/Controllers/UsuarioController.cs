using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LegaAPI.Services;

namespace LegaAPI.Controllers
{

   
    //================================================================================

    [Route("api/[Controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly AppDbContext _context;

        private string GerarSenha()
        {
            return Guid.NewGuid().ToString("N").Substring(0, 8);
        }


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
        //================================================================================

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
        //================================================================================


        [HttpPost] //adiciona um novo usuario
        public async Task<ActionResult<Usuario>> PostUsuario([FromBody] Usuario usuario)
        {

            var existe = await _context.Usuarios.AnyAsync(u => u.Email == usuario.Email);
            if (existe)
            {
                return BadRequest("Email já existe.");
            }

            usuario.PalavraPasseHash =
             BCrypt.Net.BCrypt.HashPassword(
                 usuario.PalavraPasseHash
             );

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                usuario.UsuarioId,
                usuario.Nome,
                usuario.Email
            });
        }
        //================================================================================


        [HttpPost("login")]
        public async Task<IActionResult> Login(
    [FromBody] LoginRequest request)
        {
            var usuario = await _context.Usuarios
                .FirstOrDefaultAsync(
                    u => u.Email == request.Email);

            if (usuario == null)
            {
                return Unauthorized("Email inválido");
            }

            bool passwordValida =
                BCrypt.Net.BCrypt.Verify(
                    request.Password,
                    usuario.PalavraPasseHash);

            if (!passwordValida)
            {
                return Unauthorized("Password inválida");
            }

            return Ok(new
            {
                usuario.UsuarioId,
                usuario.Nome,
                usuario.Email
            });
        }
        //================================================================================
        [HttpPost("recuperar-senha")]
        public async Task<IActionResult> RecuperarSenha([FromBody] RecuperarSenhaRequest request)
        {
            var usuario = await _context.Usuarios
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (usuario == null)
                return NotFound("Não existe conta com este e-mail.");

            var novaSenha = GerarSenha();

            usuario.PalavraPasseHash =
                BCrypt.Net.BCrypt.HashPassword(novaSenha);

            await _context.SaveChangesAsync();

            try
            {
                Console.WriteLine($"Enviar para: {usuario.Email}");

                await EmailService.Enviar(
                    usuario.Email,
                    "Recuperação de Palavra-passe",
                    $"Sua nova palavra-passe é: {novaSenha}"
                );

                Console.WriteLine("EMAIL ENVIADO");

                return Ok(new
                {
                    message = "Nova palavra-passe enviada para o seu e-mail."
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());

                return StatusCode(500, ex.Message);
            }
        }

        //================================================================================




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
        //================================================================================
        [HttpPut("{id}/email")]
        public async Task<IActionResult> AlterarEmail(int id, [FromBody] string email)
        {
            var usuario = await _context.Usuarios.FindAsync(id);

            if (usuario == null)
                return NotFound();

            usuario.Email = email;

            await _context.SaveChangesAsync();

            return Ok();
        }
        //================================================================================
        [HttpPut("{id}/password")]
        public async Task<IActionResult> AlterarPassword(
    int id,
    [FromBody] string password)
        {
            var usuario = await _context.Usuarios.FindAsync(id);

            if (usuario == null)
                return NotFound();

            usuario.PalavraPasseHash =
                BCrypt.Net.BCrypt.HashPassword(password);

            await _context.SaveChangesAsync();

            return Ok();
        }
        //================================================================================

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

