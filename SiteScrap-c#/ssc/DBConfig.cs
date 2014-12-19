using System;
using System.Collections.Generic;

using System.ComponentModel;
using System.Data;

using System.Net;
using System.IO;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Windows.Forms;

namespace ssc { 
	public class DBConfig
	{
		public MySqlConnection conn;

		public static string host = "localhost";
		public static string schema = "ssc";
		public static string user = "root";
		private static string pwd = "root";
		public  static string charset = "utf-8";
		public static string port= "3306";
		public static System.Configuration.Configuration config;
		//        private MySqlConnection conn = null;

		public static DBConfig newInstance()
		{
			return new DBConfig();
		}

		public static string getDBUrl()
		{
			return String.Format("{0}:{1}@user={2}/{3};charset={4}", host, port, user, schema, charset);
		}
		public static string getConnectionString()
		{
			try
			{
				host = System.Configuration.ConfigurationManager.AppSettings["host"];
				schema = System.Configuration.ConfigurationManager.AppSettings["database"];
				user = System.Configuration.ConfigurationManager.AppSettings["user"];
				pwd = System.Configuration.ConfigurationManager.AppSettings["password"];
				charset = System.Configuration.ConfigurationManager.AppSettings["charset"];
				port = System.Configuration.ConfigurationManager.AppSettings["port"];
			}
			catch { }
		  
// 			try
// 			{
// 				INIFile ini = new INIFile("C:\\test.ini");
// 				host = System.Configuration.ConfigurationManager.AppSettings["host"];
// 				schema = System.Configuration.ConfigurationManager.AppSettings["database"];
// 				user = System.Configuration.ConfigurationManager.AppSettings["user"];
// 				pwd = System.Configuration.ConfigurationManager.AppSettings["password"];
// 				charset = System.Configuration.ConfigurationManager.AppSettings["charset"];
// 				port = System.Configuration.ConfigurationManager.AppSettings["port"];
// 			}
// 			catch { }
			return String.Format("SERVER={0,0};Port={1,0};DATABASE={2,0};UID={3,0};PASSWORD={4,0};CHARSET={5,0};Connect Timeout=10",
							 host, port, schema, user, pwd, charset);
		}
		public static MySqlConnection getConnection()
		{
			try{
			 host =   System.Configuration.ConfigurationManager.AppSettings["host"];
			 schema  = System.Configuration.ConfigurationManager.AppSettings["database"];
			 user   = System.Configuration.ConfigurationManager.AppSettings["user"];
			 pwd   = System.Configuration.ConfigurationManager.AppSettings["password"];
			 charset   = System.Configuration.ConfigurationManager.AppSettings["charset"];
			 port = System.Configuration.ConfigurationManager.AppSettings["port"];
			}catch{}

			String MyConString = getConnectionString();

			//MessageBox.Show(MyConString);
			try
			{
				MySqlConnection cnn = new MySqlConnection(MyConString);
				
				return cnn;
				
				//this.conn.ConnectionTimeout = 1000 * 10;//10 seconds
			}
			catch (Exception e)
			{
				
			}
			return null;
		}

	

	}
}