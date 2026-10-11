using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Runtime.InteropServices;
using lms.seihaglobalacademy.com;



public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            if (Request.Cookies["LMSUserInfo"] != null)
            {
                AutoLogin();
            }
        }
    }
    protected void btnVerify_Click(object sender, EventArgs e)
    {
        if (txtUsername.Text != "" && txtPassword.Text != "")
        {
            ModGlobal mod = new ModGlobal();
            mod.loadEncryptDecrpt();
            // Successful verification -> Send them to our newly integrated dashboard
            mod.EncryptText(txtPassword.Text.Trim());
            string encryptedValue = mod.holdEtxt;

            string strQuery = "Select Count(*) from SGA_LMS.dbo.users where Username = '" + txtUsername.Text.Trim() + "' and PasswordHash = '" + encryptedValue + "' and status = 1";
            string FindMe = DataAccess.Scalar(strQuery).ToString();
            if (FindMe == "1")
            {
                string strGetRoleQuery = "Select Role from SGA_LMS.dbo.users where Username = '" + txtUsername.Text.Trim() + "' and PasswordHash = '" + encryptedValue + "' and status = 1";
                string getRole = DataAccess.Scalar(strGetRoleQuery).ToString();

                //insert a cookie to the browser with the username, password and role
                HttpCookie cookie = new HttpCookie("UserInfo");
                cookie["Username"] = txtUsername.Text.Trim();
                cookie["Password"] = txtPassword.Text.Trim();
                cookie["Role"] = getRole;
                cookie.Expires = DateTime.Now.AddDays(30); // Valid for 30 days
                Response.Cookies.Add(cookie);

                Session["Username"] = txtUsername.Text;
                Session["Role"] = getRole;
                Response.Redirect("~/Dashboard", false);
                Context.ApplicationInstance.CompleteRequest();
                //ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + FindMe + "');", true);
                //ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + encryptedValue + "');", true);
            }
            else
            {
                loginError.Visible = true;
            }
            //Response.Redirect("Dashboard.aspx");
        }
        else
        {
            // Show the built-in error message panel inside your partner's markup
            loginError.Visible = true;
        }
    }
    protected void AutoLogin()
    {
        if (Request.Cookies["UserInfo"] != null)
        {
            string username = Request.Cookies["UserInfo"]["Username"];
            string password = Request.Cookies["UserInfo"]["Password"];
            string role = Request.Cookies["UserInfo"]["Role"];
            ModGlobal mod = new ModGlobal();
            mod.loadEncryptDecrpt();

            // Successful verification -> Send them to our newly integrated dashboard
            mod.EncryptText(password);
            string encryptedValue = mod.holdEtxt;
            string strQuery = "Select Count(*) from SGA_LMS.dbo.users where Username = '" + txtUsername.Text.Trim() + "' and PasswordHash = '" + encryptedValue + "' and status = 1";
            string FindMe = DataAccess.Scalar(strQuery).ToString();

            // Perform auto-login logic here, e.g., validate the credentials and redirect to the dashboard
            if (FindMe == "1")
            {
                // Validate credentials and redirect to dashboard
                Response.Redirect("~/Dashboard", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }
    }
}