using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;



namespace lms.seihaglobalacademy.com
{
    public partial class Files : Page
    {
        private static DataTable dtQuery;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Page.Title = "Files";
            }
            getUserInfo();
        }
        protected void getUserInfo()
        {
            string username = Session["Username"] as string;
            string userrole = Session["Role"] as string;

            //query to get the user info from the database
            string strQuery = "Select UPPER(LEFT(FirstName, 1) + LEFT(LastName, 1)) AS Badge, LTRIM(RTRIM(FirstName + ISNULL(' ' + (LEFT(MiddleName, 1) + '.'), '') + ISNULL(' ' + [LastName], ''))) AS FullName from SGA_LMS.dbo.users where Username = '" + username + "' and Role = '" + userrole + "'";

            dtQuery = DataAccess.Query(strQuery);
            if(dtQuery.Rows.Count > 0)
            {
                string badge = dtQuery.Rows[0]["Badge"].ToString();
                string fullname = dtQuery.Rows[0]["FullName"].ToString();
                lblIdentBadge.Text = badge;
                lblIdentName.Text = fullname;
                lblProBreadCrumbs.Text =  fullname + " &gt; Files";
            }
        }
    }
}