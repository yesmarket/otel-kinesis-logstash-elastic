using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Reflection;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Prometheus;
using Serilog.Enrichers.Correlation;
using TestService.WebApi.Health;

namespace TestService.WebApi
{
   [ExcludeFromCodeCoverage]
   public class Startup
   {
      private readonly IConfiguration _configuration;

      public Startup(IConfiguration configuration)
      {
         _configuration = configuration;
      }

      // This method gets called by the runtime. Use this method to add services to the container.
      public void ConfigureServices(IServiceCollection services)
      {
         services.AddApiVersioning(options => options.ReportApiVersions = true);

         services
            .AddMvc()
            .AddNewtonsoftJson();

         services.AddSwaggerGen(c =>
         {
            c.SwaggerDoc("Test",
               new OpenApiInfo
               {
                  Title = "Test",
                  Version = Assembly.GetEntryAssembly()?
                     .GetCustomAttribute<AssemblyInformationalVersionAttribute>()
                     .InformationalVersion ?? "NA"
               });
         });

         services.AddCors(o => o.AddPolicy("AllowAnyOrigin", builder =>
         {
            builder
               .AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
         }));

         services.AddSingleton<HealthCheck>();
         services.AddHealthChecks()
            .AddCheck<HealthCheck>("Test");

         services.AddControllers();
      }

      // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
      public static void Configure(
         IApplicationBuilder app,
         IServiceProvider serviceProvider)
      {
         var logger = serviceProvider.GetService<ILogger<Startup>>();

         try
         {
            app.UseStaticFiles()
               .UseSwagger()
               .UseSwaggerUI(c =>
               {
                  c.SwaggerEndpoint("/swagger.json", "Test");
               });

            app.UseRouting();

            app.UseCors("AllowAnyOrigin");

            app.UseEndpoints(endpoints =>
            {
               endpoints.MapControllers();

                  endpoints.MapHealthChecks("/health");
                  endpoints.MapMetrics("/metrics");
            });

#pragma warning disable CA2000 // Dispose objects before losing scope
            DiagnosticListener.AllListeners.Subscribe(new CorrelationIdObserver());
#pragma warning restore CA2000 // Dispose objects before losing scope
         }
         catch (Exception ex)
         {
            var baseEx = ex.GetBaseException();
            logger.LogCritical($"Error during configuration of HTTP request pipeline:{Environment.NewLine}{baseEx.Message}");
#if DEBUG
            Console.ReadLine();
#endif
            throw;
         }
      }
   }
}
