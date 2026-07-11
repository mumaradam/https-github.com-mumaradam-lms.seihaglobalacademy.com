using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(lms.seihaglobalacademy.com.Startup))]
namespace lms.seihaglobalacademy.com
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
