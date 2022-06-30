using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Prometheus;

namespace TestService.WebApi.Controllers
{
   [ApiVersion("1.0")]
   [ApiController]
   [Route("v{version:apiVersion}/test")]
   public class TestController : ControllerBase
   {
      private readonly ILogger<TestController> _logger;

      private static readonly Counter RequestCounter = Metrics.CreateCounter("requests_total", "Number of requests.");

      public TestController(
         ILogger<TestController> logger)
      {
          _logger = logger;
      }

      [HttpGet]
      public IActionResult Get()
      {
          _logger.LogInformation($"Called {nameof(Get)}");

          RequestCounter.Inc();

          return Ok();
      }

      [HttpPost]
      public IActionResult Post()
      {
         _logger.LogInformation($"Called {nameof(Post)}");

         RequestCounter.Inc();

         return Ok();
      }
   }
}
