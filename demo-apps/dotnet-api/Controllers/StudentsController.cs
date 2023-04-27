using Microsoft.AspNetCore.Mvc;

namespace dotnet_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class StudentsController : ControllerBase
    {
       private readonly SchoolContext _context;
       private readonly ILogger<StudentsController> _logger;

        public StudentsController(SchoolContext context, ILogger<StudentsController> logger)
        {
           _context = context;
           _logger = logger;
        }

        [HttpGet]
        public IEnumerable<Student> Get()
        {
           _logger.LogInformation(nameof(Get));

           return _context.Students;
        }
    }
}
