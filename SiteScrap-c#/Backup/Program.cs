using System;
using System.Collections.Generic;

using System.ComponentModel;
using System.Data;

using System.Net;
using System.IO;
using MySql.Data.MySqlClient;
using System.Text;
using System.Windows.Forms;
using System.Configuration;
using ssc.games;
using System.Threading;


namespace ssc
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
		static Mutex appSingleton = null;
        [STAThread]
        static void Main()
        {
			bool bCreate = false;
			appSingleton = new System.Threading.Mutex(true, "saf-ssc-datascrape", out bCreate);
			if (!bCreate)
			{
				Application.Exit();
				return;
			}
			
			
			System.Configuration.Configuration config
				= ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
			config.AppSettings.File = "config.xml";
			config.Save(ConfigurationSaveMode.Modified); //save all info to file

			ConfigurationManager.RefreshSection("appSettings"); 
			//MessageBox.Show(config.AppSettings.Settings["connectionString"].Value);
			//DBConfig.config = config;


//			WebFetch.mysqltest();
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());


			//			so1.start();
        }
      
        
        
    }
    

    
}

#region "SSC"

namespace ssc{
     public class WebFetch
    {
        
        public static void mysqltest()
        {
            string MyConString = "SERVER=localhost;" +
                "DATABASE=ssc;" +
                "UID=root;" +
                "PASSWORD=root;";
            MySqlConnection connection = new MySqlConnection(MyConString);
			//connection.ConnectionTimeout = 1000 * 10;
            MySqlCommand command = connection.CreateCommand();
            MySqlDataReader Reader;
			command.CommandText = "select *  from fl_area where fl_code = 'fl_1'";
			MySqlDataAdapter da = new MySqlDataAdapter(command);
			DataSet ds = new DataSet();
			DataTable dt = new DataTable();
			da.Fill(ds);
			dt = ds.Tables[0];
			dt.Rows[0]["name"] = "Africa-africa";
			
			//da.(dt);
			//dt.AcceptChanges();
			da.UpdateCommand = new MySqlCommand("update fl_area set name=@name where fl_code = 'fl_1'", connection);
			da.UpdateCommand.Parameters.Add("@name", MySqlDbType.VarChar, 45, "name");
			//da.UpdateCommand.Parameters.AddWithValue("@name", "Hello world");
			da.UpdateCommand.UpdatedRowSource = UpdateRowSource.None;
			try
			{
				da.Update(ds.Tables[0]);
			}
			catch(Exception e) {
				e.ToString();
			}

			MySqlCommand cmd = new MySqlCommand("update fl_area set name=@name where fl_code = 'fl_1'", connection);
			
			da.Fill(ds);
			string ss;
			for (int k = 0; k < ds.Tables[0].Rows.Count; k++ )
				for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
				{
					ss = ds.Tables[0].Rows[k]["g_time"].ToString();
				}
			

			da.SelectCommand.CommandText = "select * from fl_area f";
			da.Fill(ds);
			ss = ds.Tables[0].Rows[1][1].GetType().ToString();
            try
            {
                connection.Open();

                Reader = command.ExecuteReader();

                command.CommandText = "select * from fl_area fa";
                Reader = command.ExecuteReader();
                while (Reader.Read())
                {
                    string thisrow = "";
                    for (int i = 0; i < Reader.FieldCount; i++)
                        thisrow += Reader.GetValue(i).ToString() + ",";


                }
				Reader.Close();
                connection.Close();
            }
            catch (Exception e)
            {
				GrabAgent.trace_log(e.Message);
            }
        }
	}
#endregion
}