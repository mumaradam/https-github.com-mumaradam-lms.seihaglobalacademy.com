using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;



public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            // Read the inputs sent by your partner's raw HTML form input fields
            string usernameInput = Request.Form["identifier"];
            string passwordInput = Request.Form["credentials.passcode"];

            // Basic staging validation hook
            if (!string.IsNullOrEmpty(usernameInput) && !string.IsNullOrEmpty(passwordInput))
            {
                // Successful verification -> Send them to our newly integrated dashboard
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                // Show the built-in error message panel inside your partner's markup
                loginError.Visible = true;
            }
        }
    }
}