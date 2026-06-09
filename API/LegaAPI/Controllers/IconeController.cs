using LegaAPI.Data;
using LegaAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LegaAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]

    public class IconeController : ControllerBase
    {
        private readonly AppDbContext _context;

        public IconeController(AppDbContext context)
        {
            _context = context;
        }


        [HttpGet]

        public async Task<ActionResult<IEnumerable<Icone>>> GetIcones()
        {
            return Ok(await _context.Icones.ToListAsync());
        }



    }
}
