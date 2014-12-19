using System;

using System.Drawing;
using System.Windows.Forms;
using System.Data;
using ssc;
using ssc.games;
using Microsoft.Win32;

namespace ssc
{
    public partial class Form1 : Form
    {
		TotalUpdater m_tu;
		RegistryKey rkApp = Registry.CurrentUser.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);

		public static Boolean isSkipConnect = false;
        public static int retryInterval = 10;//min
        public static int connectionTimeout = 5;//sec
        public Form1()
        {
			InitializeComponent();
			//SoccerObject so1 = new SoccerObject("Soccer", 3333);
			m_tu = new TotalUpdater("flashscore", 100);
			if (rkApp.GetValue("SAF_SSC") == null){
				chkRun.Checked = false;
			}else{
				chkRun.Checked = true;
			}
			btnStart_Click(null, null);
        }

		private void btnStart_Click(object sender, EventArgs e)
		{
			while (true) { 
				try{
				//test connection
					lblStatus.Text = String.Format("DB Server : [{0}]", DBConfig.getDBUrl() );
					lblStatus.Refresh();
					if ( m_tu.conn.State == ConnectionState.Closed) 
						m_tu.conn.Open();
					GrabAgent.trace_log("Mysql connection established.");
					break;
				}catch (Exception ex){
					DialogResult dr = MessageBox.Show(ex.Message + "\r\nPlease check config.xml file or contact DB Admin.\r\n Exit and reconfigure.",
						"Mysql connection error.", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1);
					if (dr == DialogResult.Abort)
					{Application.Exit(); return;}
					else if (dr == DialogResult.Ignore)
						break;
					else
						continue;
				}
				
			}

            try
            {
                retryInterval = Convert.ToInt32(txtInterval.Text);
            }
            catch (Exception)
            {
                txtInterval.Text = "10";
                retryInterval = 10;
            }
            
            try
            {
                connectionTimeout = Convert.ToInt32(txtTimeout.Text);
            }
            catch (Exception)
            {
                txtTimeout.Text = "3";
                connectionTimeout = 3;
            }
            
			btnStart.Enabled = false;
			btnStop.Enabled = true;
            groupBox1.Enabled = false;

            m_tu.start();
		}

		private void btnStop_Click(object sender, EventArgs e)
		{
			btnStart.Enabled = true;
			btnStop.Enabled = false;
            groupBox1.Enabled = true;

			m_tu.pause();
	
		}

		private void btnExit_Click(object sender, EventArgs e)
		{
			//m_tu.stop();
			//Application.ExitThread();
			
			Environment.Exit(0);
		}

		private void Form1_Load(object sender, EventArgs e)
		{
			GrabAgent.setTraceHandle(this);
			
		}
		// loging function

		public void traceLog(string value)
		{
			if (InvokeRequired)
			{
				this.Invoke(new Action<string>(traceLog), new object[] { value });
				return;
			}
			if (txtLog.Text.Length > 6500)
				txtLog.Text = "";
			txtLog.AppendText(value + "\r\n" );
			
			//txtLog.SelectionStart = txtLog.Text.Length;
			//txtLog.ScrollToCaret();

			
		}

		private void Form1_FormClosed(object sender, FormClosedEventArgs e)
		{
			btnExit_Click(null, null);
		}

		private void checkBox1_CheckedChanged(object sender, EventArgs e)
		{
			isSkipConnect = checkBox1.Checked;
		}

		private void btnRefresh_Click(object sender, EventArgs e)
		{
			m_tu.refreshData();
		}

		private void chkRun_CheckedChanged(object sender, EventArgs e)
		{
			//CheckBox chkRun = (CheckBox)sender;
			if ( chkRun.Checked  == true){
				rkApp.SetValue("SAF_SSC", Application.ExecutablePath.ToString());
			}else{
				rkApp.DeleteValue("SAF_SSC", false);
			}
		}
  
    }
    
}

