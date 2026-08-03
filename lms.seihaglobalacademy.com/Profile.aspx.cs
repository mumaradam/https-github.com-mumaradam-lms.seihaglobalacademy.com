using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace lms.seihaglobalacademy.com
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Title metadata setup dynamically displays in the Master layout header
                Page.Title = "User Profile";
            }
        }
    }
}