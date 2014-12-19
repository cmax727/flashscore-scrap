using System;
using System.Collections.Generic;

using System.ComponentModel;
using System.Data;

using System.Net;
using System.IO;
using MySql.Data.MySqlClient;
using ssc.util;


namespace ssc.games
{
	public class SoccerObject : GrabAgent
	{
		public SoccerObject(string agentName,int updateInterval)
			: base(agentName, updateInterval)
		{
			this.pageIndex = 1;
			this.GAME_TYPE = 1; // "soccer";

		}

		

		/*
		 * 
		 */ 
		public override bool _updateData(string gameStateData)
		{
			String sql = "update game_log set a0=@1, a1=@2, a2=@3, a3=@4	, b0=@5, b1=@6, b2=@7, b3=@8" +
				", s0=@9, s1=@10, s2=@11  " +
				 " where  g_code=@12 and g_type = @13;";
			return true;
		}

		/*
		 * 
		 */
		public override bool _registerData(string gameData)
		{
			String[] AAs = gameData.Split('~');
			StringRecord zRecord = null;
			try
			{
				if (!openConnection()) return false;
				String sql = "insert into game_log( gn_code, g_time, g_type, g_code, teamA, teamb,  " +
					"s0, s1, s2, " +
					"a0, a1, a2, a4,  	b0, b1, b2, b4)" +
					"values ( @1,@2,@3,@4,@5,@6,    @7,@8,@9,  @10,@11,@12,@13,		@14,@15,@16,@17)";
				// parameter type = :name, @name, ?
				//  calltype = "name", "@name", param1/2/3, parameters["name"] /parameters["@name"]/ parameters[0/1/2].value
				MySqlCommand cmd = new MySqlCommand(sql, conn);

				cmd.Prepare();
				
				StringRecord aRecord = null;
				int  gType = GAME_TYPE;//constant
				foreach (string s in AAs)
				{
					if (s.StartsWith("SA"))
					{

						//delete recored from super
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
						makeTeamData(aRecord, gType); //Team Data extract

						// start record
						int i = 1;
						mysqlSetParam(cmd, "@" + i++, zRecord.getField("ZC"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AD"));
						mysqlSetParam(cmd, "@" + i++, gType);

						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AA"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AE"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AF"));

						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AB"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AC"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AO"));

						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AG"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("BA"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("BC"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AT"));

						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AH"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("BB"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("BD"));
						mysqlSetParam(cmd, "@" + i++, aRecord.getField("AU"));
						cmd.ExecuteNonQuery();
					}

				}// endfor

			}
			catch (Exception e){
				GrabAgent.trace_log(e.StackTrace);
			}
			finally
			{
			}
			return true;
		}




	}
}