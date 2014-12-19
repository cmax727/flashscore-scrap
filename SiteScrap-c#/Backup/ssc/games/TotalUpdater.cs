using System;
using System.Collections.Generic;
using System.Text;
using MySql.Data;
using ssc.util;
using MySql.Data.MySqlClient;
using System.Data;
using System.Threading;

namespace ssc.games
{
	class TotalUpdater : GrabAgent
	{
		int[] gameTypes = {1, 2, 3, 4, 7, 12, 6}; // gamecode
        
		public TotalUpdater(string agentName, int uInterval)
			: base(agentName, uInterval)
		{
			
		}

		public override bool grab_data(DateTime? theDay)
		{
			int nowTime = 0;
			if (theDay == null)
				theDay = SiteHelper.GetNISTDate();
			//	nowTime = SiteHelper.getFSSiteTime();
			
			nowTime = SiteHelper.toSecond(theDay);
			
			GrabAgent.trace_log("============GameData for : " + theDay.Value.ToString("yyyy/MM/dd") + "============");
// 			Thread th = new Thread(new ThreadStart(this.runGrab));
// 			th.Start();
			_grab_data(nowTime);


			return true;

		}
        public override void regQueCheck()
        {
//            base.regQueCheck();
            int nowCnt = registerQueue.Count;
//            GrabAgent.trace_log("****** Now, retrying pre-failed game score refesh. ******");
            for (int i = 0; i < nowCnt; i++)
            {
                String urlReq = registerQueue.Dequeue();
                String urlData = SiteHelper.getSiteData(urlReq);
                if ( urlData == null){//fail to connect
                    base.registerQueue.Enqueue(urlReq);
                }else
                {
                    _registerData(urlData);
                }

            }

        }
		private void _grab_data(int nowTime){
			String urlScore;
			String gameData;
			
			foreach ( int gtypeCode in gameTypes){
				string gType = getGameType(gtypeCode);

				GrabAgent.trace_log("Register data for " + gType + " at:" + nowTime + "\t{");

				urlScore = "http://www.flashscore.com/x/feed/f_" + gtypeCode + "_" + nowTime + "_0_en_1";
				gameData = SiteHelper.getSiteData(urlScore, Form1.connectionTimeout * 1000);
				if ( null == gameData )//&& Form1.isSkipConnect == false)//connection failed
				{
                    registerQueue.Enqueue(urlScore);
					GrabAgent.trace_log("##### REGISTER failed for " + gType + " at:" + nowTime + "\t{");
					
					//gameData = SiteHelper.getSiteData(urlScore, 10000);
				}
				if ( gameData != null){
					deleteNowDayLog(nowTime, gtypeCode);
					_registerData(gameData);
					GrabAgent.trace_log("\tFinish register for " + gType + "\t\t}");
				}
				

			}
		}

		public override bool _registerData(string gameData){
			
			if (gameData == "") return false;
			if (!openConnection()) return false;
			
			try
			{
				
				String sql = "insert into game_log( gn_code, g_time, g_type, g_code, teamA, teamB,  " +
					"s0, s1, s2, " +
					"a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, " +
					"b0, b1, b2, b3, b4, b5, b6, b7, b8, b9 ," + 
					"updated )" +
				 "values ( @1,@2,@3,@4,@5, @6, " +
					"@s0, @s1, @s2, " +
					"@a0, @a1, @a2, @a3, @a4, @a5, @a6, @a7, @a8, @a9, " +
					"@b0, @b1, @b2, @b3, @b4, @b5, @b6, @b7, @b8, @b9, " + 
					"unix_timestamp() )" ;
				// parameter type = :name, @name, ?
				//  calltype = "name", "@name", param1/2/3, parameters["name"] /parameters["@name"]/ parameters[0/1/2].value
				MySqlCommand cmd = new MySqlCommand(sql, conn);

				cmd.Prepare();

				StringRecord aRecord = null;
				int gType = 0;
				String[] AAs = gameData.Split('~');
				StringRecord zRecord = null;
				int typeCode = 0;
				foreach (string s in AAs)
				{
					if (s.StartsWith("SA"))
					{
						aRecord = new StringRecord(s);
						typeCode = int.Parse(aRecord.getField("SA"));
						gType = typeCode;
						//gType = getGameType(typeCode);
					}
					else if (s.StartsWith("ZA")) // game name data
					{
						zRecord = null;
						zRecord = new StringRecord(s);
						makeGameName(zRecord, gType);
					}
					else if (s.StartsWith("AA"))// specific game data
					{
						aRecord = null;
						aRecord = new StringRecord(s);
						int[] teamIds = makeTeamData(aRecord, gType); //Team Data extract
						if (teamIds == null)
							continue;
						// start record
						
						mysqlSetParam(cmd, "@1" , zRecord.getField("ZC")); //gn_code
						mysqlSetParam(cmd, "@2" , aRecord.getField("AD")); //start_time
						mysqlSetParam(cmd, "@3" , gType);					//game_type
						mysqlSetParam(cmd, "@4" , aRecord.getField("AA")); //game_code
						mysqlSetParam(cmd, "@5", teamIds[0]); //teamA :aRecord.getField("AE")
						mysqlSetParam(cmd, "@6", teamIds[1]); //teamB :aRecord.getField("AF")

						//status code
						mysqlSetParam(cmd, "@s0" , aRecord.getField("AB"));
						mysqlSetParam(cmd, "@s1" , aRecord.getField("AC"));
						mysqlSetParam(cmd, "@s2" , aRecord.getField("AO"));

						//teamA data
						mysqlSetParam(cmd, "@a0" , aRecord.getField("AG"));
						mysqlSetParam(cmd, "@a1" , aRecord.getField("BA"));
						mysqlSetParam(cmd, "@a2" , aRecord.getField("BC"));
						mysqlSetParam(cmd, "@a3" , aRecord.getField("BE"));
						mysqlSetParam(cmd, "@a4" , aRecord.getField("BG"));
						mysqlSetParam(cmd, "@a5" , aRecord.getField("BI"));
						mysqlSetParam(cmd, "@a6" , aRecord.getField("DA"));
						mysqlSetParam(cmd, "@a7" , aRecord.getField("DC"));
						mysqlSetParam(cmd, "@a8" , aRecord.getField("DE"));
						mysqlSetParam(cmd, "@a9" , aRecord.getField("AT"));

						//teamB data
						mysqlSetParam(cmd, "@b0" , aRecord.getField("AH"));
						mysqlSetParam(cmd, "@b1" , aRecord.getField("BB"));
						mysqlSetParam(cmd, "@b2" , aRecord.getField("BD"));
						mysqlSetParam(cmd, "@b3" , aRecord.getField("BF"));
						mysqlSetParam(cmd, "@b4" , aRecord.getField("BH"));
						mysqlSetParam(cmd, "@b5" , aRecord.getField("BJ"));
						mysqlSetParam(cmd, "@b6" , aRecord.getField("DB"));
						mysqlSetParam(cmd, "@b7" , aRecord.getField("DD"));
						mysqlSetParam(cmd, "@b8" , aRecord.getField("DF"));
						mysqlSetParam(cmd, "@b9" , aRecord.getField("AU"));
						
						try{
							cmd.ExecuteNonQuery();
							
						}catch(Exception e){}
					}

				}// endfor
				
			}
			catch (Exception e)
			{
				GrabAgent.trace_log(e.StackTrace);
			}
			finally
			{
			}
			return true;
		}

		private string[] _delimGame = new string[] { "SA÷" ,};
		private char _delimRecord = '~';

		public override void syncData() {
			string updateData = SiteHelper.getSiteData(urlUpdateAll);
			_updateData(updateData);
		}

		public override bool _updateData(string gameData)
		{
			if (gameData == "" || gameData == null )
			{
				GrabAgent.trace_log("No data.");
				return false;
			}

			if (!openConnection()) return false;

			String sqlRetrieve = "select * from game_log g where g_code=@c1 and g_type=@c2";
			MySqlCommand cmdRetrieve = new MySqlCommand(sqlRetrieve, conn);
			cmdRetrieve.Prepare();

			String sqlUpdate = "update game_log set s0=@s0, s1=@s1, s2=@s2, " +
				" a0=@a0, a1=@a1, a2=@a2, a3=@a3, a4=@a4, a5=@a5, a6=@a6, a7=@a7, a8=@a8, a9=@a9, " +
				" b0=@b0, b1=@b1, b2=@b2, b3=@b3, b4=@b4, b5=@b5, b6 =@b6, b7=@b7, b8=@b8, b9=@b9, " +
				" updated = unix_timestamp() " + 
				" where  1=1 and g_code=@c1  and g_type=@c2";
			MySqlCommand cmdUpdate = new MySqlCommand(sqlUpdate, conn);
			cmdUpdate.CommandTimeout = 2000;

			cmdUpdate.Prepare();
			

			try
			{
				StringRecord aRecord = null;
				string  sg_type = "";
				String[] AAs = gameData.Split('~');
				StringRecord zRecord = null;

				MySqlDataAdapter da = new MySqlDataAdapter(cmdRetrieve);
				DataTable dt = new DataTable();
				DataRow dr;
				int typeCode = 0;

				foreach (string s in AAs)
				{
					aRecord = new StringRecord(s);
					
					if (s.StartsWith("SA"))
					{
						typeCode = int.Parse(aRecord.getField("SA"));

						sg_type = getGameType(typeCode);

					}
					else if (s.StartsWith("ZA"))
					{
						//no such case
					}
					else if (s.StartsWith("AA"))
					{
						if (sg_type == "") continue; //unregistered game

						try
						{
							//retrieve exisiting data
							mysqlSetParam(cmdRetrieve, "@c1", aRecord.getField("AA"));
							mysqlSetParam(cmdRetrieve, "@c2", typeCode);
							
							dt.Clear();
							da.Fill(dt);
							dr = dt.Rows[0];

							// update operation
//							mysqlSetParam(cmdUpdate, "@s0", aRecord.getField("AB") ?? dr["s0"]); //equivalent as bellow 
							
							//status data
							mysqlSetParam(cmdUpdate, "@s0", gmv(aRecord, "AB", dr, "s0"));
							mysqlSetParam(cmdUpdate, "@s1", gmv(aRecord, "AC", dr, "s1"));
							mysqlSetParam(cmdUpdate, "@s2", gmv(aRecord, "AO", dr, "s2"));

							//teamA data
							mysqlSetParam(cmdUpdate, "@a0", gmv(aRecord, "AG", dr, "a0"));
							mysqlSetParam(cmdUpdate, "@a1", gmv(aRecord, "BA", dr, "a1"));
							mysqlSetParam(cmdUpdate, "@a2", gmv(aRecord, "BC", dr, "a2"));
							mysqlSetParam(cmdUpdate, "@a3", gmv(aRecord, "BE", dr, "a3"));
							mysqlSetParam(cmdUpdate, "@a4", gmv(aRecord, "BG", dr, "a4"));
							mysqlSetParam(cmdUpdate, "@a5", gmv(aRecord, "BI", dr, "a5"));
							mysqlSetParam(cmdUpdate, "@a6", gmv(aRecord, "DA", dr, "a6"));
							mysqlSetParam(cmdUpdate, "@a7", gmv(aRecord, "DC", dr, "a7"));
							mysqlSetParam(cmdUpdate, "@a8", gmv(aRecord, "DE", dr, "a8"));
							mysqlSetParam(cmdUpdate, "@a9", gmv(aRecord, "AT", dr, "a9"));

							//teamB data
							mysqlSetParam(cmdUpdate, "@b0", gmv(aRecord, "AH", dr, "b0"));
							mysqlSetParam(cmdUpdate, "@b1", gmv(aRecord, "BB", dr, "b1"));
							mysqlSetParam(cmdUpdate, "@b2", gmv(aRecord, "BD", dr, "b2"));
							mysqlSetParam(cmdUpdate, "@b3", gmv(aRecord, "BF", dr, "b3"));
							mysqlSetParam(cmdUpdate, "@b4", gmv(aRecord, "BH", dr, "b4"));
							mysqlSetParam(cmdUpdate, "@b5", gmv(aRecord, "BJ", dr, "b5"));
							mysqlSetParam(cmdUpdate, "@b6", gmv(aRecord, "DB", dr, "b6"));
							mysqlSetParam(cmdUpdate, "@b7", gmv(aRecord, "DD", dr, "b7"));
							mysqlSetParam(cmdUpdate, "@b8", gmv(aRecord, "DF", dr, "b8"));
							mysqlSetParam(cmdUpdate, "@b9", gmv(aRecord, "AU", dr, "b9"));

							//game code
							string ss = aRecord.getField("AA");
							mysqlSetParam(cmdUpdate, "@c1", ss);
							mysqlSetParam(cmdUpdate, "@c2", typeCode);
							int rows = cmdUpdate.ExecuteNonQuery();
							if (rows > 1)
							{
								//System.Windows.Forms.MessageBox.Show(rows + " rows updated. It's strange!!!!!!\r\n" + "G_CODE=" + ss + "G_TYPE=" + sg_type);//???
							}

						}
						catch (IndexOutOfRangeException ie)
						{
							//String rd = SiteHelper.getSiteData(urlRetrieveAll);
							//_registerData(rd);???
						}
						catch (Exception e){
							GrabAgent.trace_err(e.Message);
						}
					}

				}

				GrabAgent.trace_log("Data updated.");

			}
			catch (Exception e)
			{
				GrabAgent.trace_log(e.Message);
			}
			return true;
			
		}

	}
	//=========== end class
}
