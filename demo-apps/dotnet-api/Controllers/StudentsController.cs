using Microsoft.AspNetCore.Mvc;

namespace dotnet_api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class StudentsController : ControllerBase
    {
       private readonly SchoolContext _context;
       private readonly ILogger<StudentsController> _logger;

        public StudentsController(SchoolContext context, ILogger<StudentsController> logger)
        {
           _context = context;
           _logger = logger;
        }

        [HttpGet("{id}")]
        public IEnumerable<Student> Get(int id)
        {
            if (id == 3) {
               throw new ApplicationException("user with id of 3 is invalid!");
            }

            // log something unique so I can search for this in Elastic
           _logger.LogInformation("qwerty12345");

           return _context.Students;
        }
    }
}
