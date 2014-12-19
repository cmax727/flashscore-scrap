using System;
using System.Collections.Generic;

using System.ComponentModel;
using System.Data;

using System.Net;
using System.IO;
using MySql.Data.MySqlClient;
using System.Text;
using System.Threading;
using ssc.util;
using System.Diagnostics;

namespace ssc
{
	public abstract class GrabAgent
	{
		public const string FS_TIMEURL = "http://www.flashscore.com/x/feed/utime";
		public const string FS_SYNCURL = "http://www.flashscore.com/x/feed/sys";

		public MySqlConnection conn;
		//protected MySqlDataAdapter dbAdapter;
		public string AgentName="";
		protected int pageIndex;	// site_gametype identifier #
		protected int GAME_TYPE;    // gametype identifer code

		protected int iGrabInterval = 30; //minutes
		protected int updateInterval = 1000;//milliseconds
		protected int timeZone = 0; // GMT +0
		protected int iNow = 0; // represent sync now time;

		protected string urlUpdateAll = "http://www.flashscore.com/x/feed/u_0_1";	// All updated data
		protected string urlRetrieveAll = "http://www.flashscore.com/x/feed/r_0_1";	// All updated data
		protected string urlUpdate;	// update data url
		protected string urlRetrieve; // retrieve data  url
		protected string urlScoreT;

        public Queue<String> registerQueue = new Queue<String>();

		public abstract bool _updateData(String gameStateData);
		public abstract bool _registerData(String gameData);

		public Boolean m_bRefresh = false;
		Thread theThread;
		//public static StreamWriter logFile;
		public GrabAgent(string agentName, int uInterval)
		{
			this.AgentName = agentName;
			this.updateInterval = uInterval;
			this.conn = DBConfig.getConnection();
			//this.dbAdapter = new MySqlDataAdapter();

			theThread = new Thread(new ThreadStart(this.runUpdate));
		}

		public virtual void syncData()
		{
			String gameStateData = SiteHelper.getSiteData(this.urlUpdate);
			
			_updateData(gameStateData);
		}

		public bool grab_data()
		{
			return grab_data(null);
		}

		public virtual bool grab_data(DateTime? theDay)
		{
			if (theDay == null)
				this.iNow = SiteHelper.getFSSiteTime();
			else
			{
				this.iNow = SiteHelper.toSecond(theDay);
			}
			GrabAgent.trace_log("Register data for time: " + iNow + "{");

			String urlScore = String.Format(this.urlScoreT, iNow);
			String gameData = SiteHelper.getSiteData(urlScore);
			if (gameData == ""  )
			{
				this.iNow = 0; return false;
			}
			deleteNowDayLog(iNow, this.GAME_TYPE);
			return _registerData(gameData);
			
			GrabAgent.trace_log("\tFinish register for time: " + iNow + "}");
		}

		
		protected void url_construct(){
			this.urlUpdate = "http://www.flashscore.com/x/feed/u_"+ pageIndex + "_1";
			this.urlRetrieve = "http://www.flashscore.com/x/feed/r_"+ pageIndex + "_1";
			this.urlScoreT = "http://www.flashscore.com/x/feed/f_" + pageIndex + "_{0}_" + timeZone + "_en_1";
			

		}

		private bool bFirst = false;
		public void start()
		{
			if (!bFirst)
			{
				url_construct();

				GrabAgent.trace_log("Grab Started.");
				theThread.Start();

				return;
			}

			theThread.Resume();
			GrabAgent.trace_log("Updating is running");
		}

		
		public void pause()
		{
			theThread.Suspend();
			GrabAgent.trace_log("Updating is paused");
		}

		public void stop()
		{
			try
			{
				try
				{
					theThread.Resume();
				}
				catch { }
				theThread.Abort();
			}
			catch { }
			
		}
        public virtual void regQueCheck(){
        }
		public void runUpdate()
		{

			bFirst = true;

			DateTime dxT = SiteHelper.GetNISTDate();
			for (int idx = -3; idx < 4; idx++)// today, 3 days before, 3 days future
			{
				grab_data(dxT.AddDays(idx));
			}
			

			int i = 0;
			string szDecorate = "++++++++++++++++++++++";
			Stopwatch sw = Stopwatch.StartNew();
			long x = 0;
			long preX = 0;

            int retryInterval = Form1.retryInterval;
			int a1=0, a2=0, a3 = 0;
			while (true) {
                i %= 10;
                i++;

				Thread.Sleep(updateInterval);
				syncData();

				//GrabAgent.trace_log(this.AgentName +"\t" +szDecorate.Substring(i*2));
				GrabAgent.trace_log(szDecorate.Substring(i * 2));

				if (m_bRefresh == true)
				{
					GrabAgent.trace_log("============ Manual Refresh : " + DateTime.Now.ToString("yyyy/MM/dd") + "============");
					grab_data();
					m_bRefresh = false;
				}

				x = 1 + sw.ElapsedMilliseconds / 1000 / 60;//minutes
				
				if (preX == x)
					continue;
				preX = x;
				a1++;
				a2++;
				a3++;

				

				if (a2 > Form1.retryInterval )
				{
					a2 = 0;
					GrabAgent.trace_log("****** Now, retrying pre-failed game score refesh. ******");
					regQueCheck();
				}
				

				if (a1 >60)//1 hours : re_register
				{
					a1 =0;
					//refresh_sync
					DateTime dt = SiteHelper.GetNISTDate();
					GrabAgent.trace_log("============ Auto Refresh(interval 1 hr): " + dt.ToString("yyyy/MM/dd") + "============");
					//dt = dt.add
					grab_data(dt.AddDays(-1));
					grab_data(dt);
					grab_data(dt.AddDays(1));

				}

				if (x > 1440 )
				{ // a day after
					sw.Reset();
					DateTime dt = SiteHelper.GetNISTDate();
					GrabAgent.trace_log("============ Auto Refresh(interval 1 day): " + dt.ToString("yyyy/MM/dd") + "============");
					dt = dt.AddDays(-1);
					for (int k = 0; k < 2; k++)
					{
						//continue;
						dt = dt.AddDays(1);
						grab_data(dt);
					}
				}


			}
		}

		public void refreshData(){
			m_bRefresh = true;
		}
		protected int[] makeTeamData(StringRecord aRecord, int gtype)
		{
			MySqlDataAdapter da;
			
			try
			{
				if (!openConnection()) return null;

				String tsql = @"insert into team_data(t_name, g_type, fl_code)  values (@a, @b, @c)";
				MySqlCommand cmd = new MySqlCommand(tsql, this.conn);
				cmd.Prepare();

				cmd.Parameters.AddWithValue("@a", aRecord.getField("AE"));
				cmd.Parameters.AddWithValue("@b", gtype);
				cmd.Parameters.AddWithValue("@c", "");
				
				try
				{
					cmd.ExecuteNonQuery(); // teamA

				}
				catch (Exception ex) { }

				cmd.Parameters["@a"].Value = aRecord.getField("AF");
				try
				{
					cmd.ExecuteNonQuery(); // teamB
				}
				catch (Exception ex) { }
				
				
				tsql = @"select t_id from team_data where g_type =" + gtype + " and t_name = '" + aRecord.getField("AE") + "'";
				cmd = new MySqlCommand(tsql, this.conn);
				int teama = (int)cmd.ExecuteScalar();

				tsql = @"select t_id from team_data where g_type =" + gtype + " and t_name = '" + aRecord.getField("AF") + "'";
				MySqlCommand cmd2 = new MySqlCommand(tsql, this.conn);
				int teamb = (int)cmd2.ExecuteScalar();				
				cmd = null; cmd2 = null;
				
				int[] result = new int[2]{teama, teamb};
				return result;
				
			}
			catch(Exception eex) { }
			return null;
		}

		/*
		 * 
		 */ 
		protected void makeGameName(StringRecord zRecord, int gtype )
		{
			String ZC = zRecord.getField("ZC"); //g_code
			String ZB = zRecord.getField("ZB"); //fl_code
			String ZA = zRecord.getField("ZA"); //game_name

			String sql = "insert into game_name(gn_code, gn_name, g_type, fl_code) values (@1, @2, @3, @4)";
			
			try
			{
				if (!openConnection()) return;

				MySqlCommand cmd = conn.CreateCommand();
				cmd.CommandText = sql;
				
				cmd.Parameters.AddWithValue("@1",ZC);
				cmd.Parameters.AddWithValue("@2", ZA);
				cmd.Parameters.AddWithValue("@3", gtype);
				cmd.Parameters.AddWithValue("@4", ZB);

				
				
				cmd.ExecuteNonQuery();
			}
			catch (Exception e) {
				//System.Console.WriteLine(e.Message);
			}
			finally
			{
				sql = null;
				ZC = null;
				ZB = null;
				ZA = null;

				
			}
			
		}

		protected void deleteNowDayLog(int nowTime, int gtype){

			int now = nowTime - (nowTime % (3600 * 24));
			int next = now + 3600 * 24;
			String sql = "delete from game_log where g_type=@1 and g_time>=@2 and g_time < @3";
			MySqlCommand cmd = new MySqlCommand(sql, this.conn);

			if (!openConnection()) return;

			try{
				cmd.Parameters.AddWithValue("@1", gtype);
				cmd.Parameters.AddWithValue("@2", now);
				cmd.Parameters.AddWithValue("@3", next);
			
				cmd.ExecuteNonQuery();
			}catch(Exception e){
				GrabAgent.trace_log(e.StackTrace);
			}finally{
				//closeConnection();
			}
		}
		
		protected bool openConnection()
		{
			try
			{
				if ( conn.State == ConnectionState.Open)
					return true;
				conn.Open();
				return true;
			}
			catch (Exception ex)
			{
				GrabAgent.trace_err("Mysql connection failed.");
				return false;
			}
		}

		//Close connection
		private bool closeConnection()
		{
			try
			{
				conn.Close();
				return true;
			}
			catch{				
				return false;
			}
		}

		protected void mysqlSetParam(MySqlCommand cmd, String pname, object value)
		{
			if (cmd.Parameters.Contains(pname))
				cmd.Parameters[pname].Value = value;
			else
				cmd.Parameters.AddWithValue(pname, value);
		}

		protected string getGameType(int typeCode)
		{
			string gtype = "";
			switch (typeCode)
			{
				case 1:
					gtype = "soccer";
					break;
				case 2:
					gtype = "tennis";
					break;
				case 3:
					gtype = "basketball";
					break;
				case 4:
					gtype = "hockey";
					break;
				case 7:
					gtype = "handball";
					break;
				case 12:
					gtype = "volleyball";
					break;
				case 6:
					gtype = "baseball";
					break;

			}
			return gtype;
		}

		//get modified value
		public object gmv(StringRecord newData,String fieldName, DataRow oldData, String rowName)
		{
			string sd = newData.getField(fieldName);
			if (sd != null)
				return sd;
			else
				return oldData[rowName];
			
		}

		//trace logs
		private static ssc.Form1 outHandler;

		public static void trace_err(String szLog)
		{
			System.Console.WriteLine(szLog);
			//return;
			if (outHandler != null)
			{
				outHandler.traceLog("ERROR: **************\t " + szLog + "\t**************");
			}


		}
		
		public static void trace_log(String szLog)
		{
			System.Console.WriteLine(szLog);

			if ( szLog.StartsWith("++") || szLog.StartsWith("Data updated")){

			}else
			{	
				StreamWriter logFile;
				if (!File.Exists("scrape_ssc.log"))
				{
					logFile = new StreamWriter("scrape_ssc.log");
				}
				else
				{
					logFile = File.AppendText("scrape_ssc.log");
				}
				logFile.WriteLine(DateTime.Now);
				logFile.WriteLine(szLog);
				logFile.WriteLine();
				logFile.Close();

				FileInfo fInfo = new FileInfo(@"scrape_ssc.log");
				long size = fInfo.Length;
				
				if (size > 1024 * 1024 * 10)
				{ //10 MB
					File.Move("scrape_ssc.log", "scrape_ssc" + DateTime.Now.ToString("yyyy-mm-dd") + ".log");
				}
			}
			
			//return;
			if ( outHandler!= null)
			{
				outHandler.traceLog(szLog);
			}
		}

		public static void setTraceHandle(ssc.Form1 outBox)
		{
			
			outHandler = outBox;
		}

		~GrabAgent(){
			//logFile.Close();
		}
	}

}

