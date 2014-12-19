using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;
using ssc;
using System.Diagnostics;


namespace ssc.util
{
	//==============================
	public class SiteHelper
	{

		public static string getSiteData(string urlReq)
		
		{
			return getSiteData(urlReq, 3000);
		}

		public static string getSiteData(String urlReq, int timeout )
		{
			Stopwatch sw = Stopwatch.StartNew();
			
			try
			{
				
				//GrabAgent.trace_log("+++++++++++++++++++++      {{");
			
				HttpWebRequest request = (HttpWebRequest)
					WebRequest.Create(urlReq);
                request.Headers.Add("X-Fsign", "SW9D1eZo");
				request.Timeout = timeout;//5 seconds

				HttpWebResponse response = (HttpWebResponse)
					request.GetResponse();

				// we will read data via the response stream
				Stream resStream = response.GetResponseStream();

				resStream.ReadTimeout = timeout;

				StringBuilder sb = new StringBuilder();
				byte[] buf = new byte[8192];
				string tempString = null;
				int count = 0;

				do
				{
					// fill the buffer with data
					count = resStream.Read(buf, 0, buf.Length);

					// make sure we read some data
					if (count != 0)
					{
						// translate from bytes to ASCII text
						tempString = Encoding.UTF8.GetString(buf, 0, count);
						// continue building the string
						sb.Append(tempString);
					} 
				} while (count > 0); // any more data to read?

				return sb.ToString();
			}
			catch(Exception ex)
			{
				//GrabAgent.trace_err("Http connection timeout(" + sw.ElapsedMilliseconds + ") at URL(" + urlReq + ")");
				GrabAgent.trace_err("Http connection timeout(" + sw.ElapsedMilliseconds + ") at URL(" + "**" + ")");
                return null;
			}
			finally
			{
				sw.Stop();

				//GrabAgent.trace_log("--------------------------------------------- " + sw.ElapsedMilliseconds + "}}");
			}
			return "";// null
			
		}

		/************************************************************************/
		/* get the time from http://www.flashscore.com/x/feed/utime 
		 *  return (int): seconds from 1970/01/01:00:00
		 *       or localtime if the site connection failed
		/************************************************************************/
		public static int getFSSiteTime()
		{
			DateTime dt = GetNISTDate();
			return toSecond(dt);
			//???
			string szTime = getSiteData(GrabAgent.FS_TIMEURL);
			if ("".Equals(szTime))
				return 0;
			try
			{
				return int.Parse(szTime)/3600/24 * 3600 * 24;
			}
			catch 
			{
				return 0;
			}
		}

		public static DateTime GetNISTDate()
		{
			System.Random ran = new System.Random(DateTime.Now.Millisecond);
			DateTime date = DateTime.Now;
			string serverResponse = string.Empty;

			// Represents the list of NIST servers
			string[] servers = new string[] {
                         "nist1-ny.ustiming.org",
                         "time-a.nist.gov",
                         "nist1-chi.ustiming.org",
                         "time.nist.gov",
                         "ntp-nist.ldsbc.edu",
                         "nist1-la.ustiming.org"                         
                          };

			// Try each server in random order to avoid blocked requests due to too frequent request
			for (int i = 0; i < 5; i++)
			{
				try
				{
					// Open a StreamReader to a random time server
					StreamReader reader = new StreamReader(new System.Net.Sockets.TcpClient(servers[ran.Next(0, servers.Length)], 13).GetStream());
					serverResponse = reader.ReadToEnd();
					reader.Close();

					// Check to see that the signature is there
					if (serverResponse.Length > 47 && serverResponse.Substring(38, 9).Equals("UTC(NIST)"))
					{
						// Parse the date
						int jd = int.Parse(serverResponse.Substring(1, 5));
						int yr = int.Parse(serverResponse.Substring(7, 2));
						int mo = int.Parse(serverResponse.Substring(10, 2));
						int dy = int.Parse(serverResponse.Substring(13, 2));
						int hr = int.Parse(serverResponse.Substring(16, 2));
						int mm = int.Parse(serverResponse.Substring(19, 2));
						int sc = int.Parse(serverResponse.Substring(22, 2));

						if (jd > 51544)
							yr += 2000;
						else
							yr += 1999;

						//date = new DateTime(yr, mo, dy, hr, mm, sc);
						date = new DateTime(yr, mo, dy);
						// Exit the loop
						break;
					}

				}
				catch (Exception ex)
				{
					/* Do Nothing...try the next server */
				}
			}

			return date;
		}

		public static int toSecond(DateTime? dt)
		{
			if (dt == null) dt = DateTime.Now;
			DateTime baseDt = new DateTime(1970, 1, 1);
			long x = (dt.GetValueOrDefault().Ticks- baseDt.Ticks) / TimeSpan.TicksPerMillisecond;
			
			
			//x -= dt.getTimezoneOffset() * 60 * 1000;
			x = (x / 1000 / 3600 / 24); // dd:00:00

			return (int)(x * 24 * 3600); // seconds for date
		}
	
	}

	//=======================
	public class StringRecord
	{
		string szData = null;
		static string delim = @"¬";
		static string eqsign = @"÷";

		//	ResultSet rs;
		public StringRecord(String data)
		{
			this.szData = data;
		}

		public String getField(String fname)
		{
			int iStart = szData.IndexOf(fname + eqsign);
			if (iStart < 0) return null;
			
			int iV0 = szData.IndexOf(eqsign, iStart) + 1 ;
			int iV1 = szData.IndexOf(delim, iV0);
			try
			{
				return szData.Substring(iV0, iV1-iV0);
			}
			catch{
				
			}
			return null;
		}
	}

}
