using dotnet_api;
using OpenTelemetry.Exporter;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Prometheus;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

var basePath = Environment.GetEnvironmentVariable("CONFIG_DIR") ?? Directory.GetCurrentDirectory();
builder.Configuration.SetBasePath(basePath);
builder.Configuration.AddJsonFile("appsettings.json", false, false);
var environment = Environment.GetEnvironmentVariable("ENVIRONMENT");
if (!string.IsNullOrEmpty(environment))
   builder.Configuration.AddJsonFile($"appsettings.{environment}.json", false, false);
builder.Configuration.AddEnvironmentVariables();

builder.Host.UseSerilog((context, configuration) => configuration.ReadFrom.Configuration(context.Configuration));

builder.Services.AddOpenTelemetry()
   .ConfigureResource(resourceBuilder =>
      resourceBuilder.AddTelemetrySdk())
   .WithTracing(tracerProviderBuilder =>
      tracerProviderBuilder
         .AddAspNetCoreInstrumentation()
         .AddEntityFrameworkCoreInstrumentation()
         .AddOtlpExporter(opt => opt.Protocol = OtlpExportProtocol.HttpProtobuf));
   // .WithMetrics(providerBuilder =>
   //    providerBuilder
   //       .AddAspNetCoreInstrumentation()
   //       .AddRuntimeInstrumentation()
   //       .AddProcessInstrumentation()
   //       .AddOtlpExporter(options => options.Protocol = OtlpExportProtocol.HttpProtobuf));


builder.Services.AddDbContext<SchoolContext>();

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

InitializeDatabase(app);

app.UseSwagger();
app.UseSwaggerUI();

app.UseRouting();

app.UseEndpoints(endpoints =>
{
   endpoints.MapMetrics();

   endpoints.MapControllers();
});

app.Run();

static void InitializeDatabase(IApplicationBuilder app)
{
   using var serviceScope = app.ApplicationServices.GetService<IServiceScopeFactory>()!.CreateScope();

   var context = serviceScope.ServiceProvider.GetRequiredService<SchoolContext>();
   if (!context.Database.EnsureCreated()) return;

   var course = new Course { Credits = 10, Title = "Object Oriented Programming 1" };

   context.Enrollments.Add(new Enrollment
   {
      Course = course,
      Student = new Student { FirstMidName = "Rafael", LastName = "Foo", EnrollmentDate = DateTime.UtcNow }
   });
   context.Enrollments.Add(new Enrollment
   {
      Course = course,
      Student = new Student { FirstMidName = "Pascal", LastName = "Bar", EnrollmentDate = DateTime.UtcNow }
   });
   context.Enrollments.Add(new Enrollment
   {
      Course = course,
      Student = new Student { FirstMidName = "Michael", LastName = "Baz", EnrollmentDate = DateTime.UtcNow }
   });
   context.SaveChangesAsync();
}
