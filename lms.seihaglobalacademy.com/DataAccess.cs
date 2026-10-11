using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lms.seihaglobalacademy.com
{
    public class DataAccess
    {
        private static string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;

        public static DataTable Query(string sql, params SqlParameter[] parameters)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    dt.Load(reader);
                }
            }

            return dt;
        }

        public static int Execute(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public static object Scalar(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                conn.Open();
                return cmd.ExecuteScalar();
            }
        }
    }
}