using System;
using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Diagnostics;
using Microsoft.Framework.DependencyInjection;

namespace FitLog.Api
{
    public class Startup
    {
        public void Configure(IApplicationBuilder app)
        {
            app.UseMvc();

            // TODO: move this to ConfigureDevelopment
            app.UseErrorPage(ErrorPageOptions.ShowAll);
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
        }
    }
}
