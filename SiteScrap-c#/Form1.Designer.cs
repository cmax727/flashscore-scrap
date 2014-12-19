namespace ssc
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
			this.btnStop = new System.Windows.Forms.Button();
			this.btnStart = new System.Windows.Forms.Button();
			this.btnExit = new System.Windows.Forms.Button();
			this.lblStatus = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.txtLog = new System.Windows.Forms.TextBox();
			this.checkBox1 = new System.Windows.Forms.CheckBox();
			this.btnRefresh = new System.Windows.Forms.Button();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.chkRun = new System.Windows.Forms.CheckBox();
			this.txtTimeout = new System.Windows.Forms.TextBox();
			this.txtInterval = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// btnStop
			// 
			this.btnStop.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnStop.Enabled = false;
			this.btnStop.Location = new System.Drawing.Point(265, 525);
			this.btnStop.Name = "btnStop";
			this.btnStop.Size = new System.Drawing.Size(129, 53);
			this.btnStop.TabIndex = 0;
			this.btnStop.Text = "Stop";
			this.btnStop.UseVisualStyleBackColor = true;
			this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
			// 
			// btnStart
			// 
			this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnStart.Location = new System.Drawing.Point(131, 525);
			this.btnStart.Name = "btnStart";
			this.btnStart.Size = new System.Drawing.Size(129, 53);
			this.btnStart.TabIndex = 0;
			this.btnStart.Text = "Start";
			this.btnStart.UseVisualStyleBackColor = true;
			this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
			// 
			// btnExit
			// 
			this.btnExit.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnExit.Location = new System.Drawing.Point(552, 524);
			this.btnExit.Name = "btnExit";
			this.btnExit.Size = new System.Drawing.Size(129, 53);
			this.btnExit.TabIndex = 0;
			this.btnExit.Text = "Exit";
			this.btnExit.UseVisualStyleBackColor = true;
			this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
			// 
			// lblStatus
			// 
			this.lblStatus.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.lblStatus.Location = new System.Drawing.Point(128, 488);
			this.lblStatus.Name = "lblStatus";
			this.lblStatus.Size = new System.Drawing.Size(551, 29);
			this.lblStatus.TabIndex = 2;
			this.lblStatus.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(9, 139);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(551, 17);
			this.label1.TabIndex = 2;
			this.label1.Text = "Running status";
			// 
			// txtLog
			// 
			this.txtLog.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.txtLog.Location = new System.Drawing.Point(12, 159);
			this.txtLog.MaxLength = 65536;
			this.txtLog.Multiline = true;
			this.txtLog.Name = "txtLog";
			this.txtLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
			this.txtLog.Size = new System.Drawing.Size(668, 317);
			this.txtLog.TabIndex = 1;
			// 
			// checkBox1
			// 
			this.checkBox1.AutoSize = true;
			this.checkBox1.Location = new System.Drawing.Point(457, 28);
			this.checkBox1.Name = "checkBox1";
			this.checkBox1.Size = new System.Drawing.Size(179, 21);
			this.checkBox1.TabIndex = 3;
			this.checkBox1.Text = "skip connection timeout:";
			this.checkBox1.UseVisualStyleBackColor = true;
			this.checkBox1.Visible = false;
			this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
			// 
			// btnRefresh
			// 
			this.btnRefresh.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.btnRefresh.Location = new System.Drawing.Point(417, 524);
			this.btnRefresh.Name = "btnRefresh";
			this.btnRefresh.Size = new System.Drawing.Size(129, 53);
			this.btnRefresh.TabIndex = 0;
			this.btnRefresh.Text = "Refresh Score";
			this.btnRefresh.UseVisualStyleBackColor = true;
			this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
			// 
			// groupBox1
			// 
			this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.groupBox1.Controls.Add(this.chkRun);
			this.groupBox1.Controls.Add(this.txtTimeout);
			this.groupBox1.Controls.Add(this.txtInterval);
			this.groupBox1.Controls.Add(this.label5);
			this.groupBox1.Controls.Add(this.label3);
			this.groupBox1.Controls.Add(this.label4);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Controls.Add(this.checkBox1);
			this.groupBox1.Location = new System.Drawing.Point(15, 25);
			this.groupBox1.Margin = new System.Windows.Forms.Padding(4);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Padding = new System.Windows.Forms.Padding(4);
			this.groupBox1.Size = new System.Drawing.Size(665, 97);
			this.groupBox1.TabIndex = 4;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Advanced Options";
			// 
			// chkRun
			// 
			this.chkRun.AutoSize = true;
			this.chkRun.Location = new System.Drawing.Point(457, 64);
			this.chkRun.Name = "chkRun";
			this.chkRun.Size = new System.Drawing.Size(121, 21);
			this.chkRun.TabIndex = 6;
			this.chkRun.Text = "Run on startup";
			this.chkRun.UseVisualStyleBackColor = true;
			this.chkRun.CheckedChanged += new System.EventHandler(this.chkRun_CheckedChanged);
			// 
			// txtTimeout
			// 
			this.txtTimeout.Location = new System.Drawing.Point(163, 27);
			this.txtTimeout.Margin = new System.Windows.Forms.Padding(4);
			this.txtTimeout.Name = "txtTimeout";
			this.txtTimeout.Size = new System.Drawing.Size(59, 22);
			this.txtTimeout.TabIndex = 5;
			this.txtTimeout.Text = "5";
			// 
			// txtInterval
			// 
			this.txtInterval.Location = new System.Drawing.Point(163, 60);
			this.txtInterval.Margin = new System.Windows.Forms.Padding(4);
			this.txtInterval.Name = "txtInterval";
			this.txtInterval.Size = new System.Drawing.Size(59, 22);
			this.txtInterval.TabIndex = 5;
			this.txtInterval.Text = "10";
			// 
			// label5
			// 
			this.label5.AutoSize = true;
			this.label5.Location = new System.Drawing.Point(228, 31);
			this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(30, 17);
			this.label5.TabIndex = 4;
			this.label5.Text = "sec";
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(228, 65);
			this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(30, 17);
			this.label3.TabIndex = 4;
			this.label3.Text = "min";
			// 
			// label4
			// 
			this.label4.AutoSize = true;
			this.label4.Location = new System.Drawing.Point(11, 31);
			this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(133, 17);
			this.label4.TabIndex = 4;
			this.label4.Text = "Connection timeout:";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(11, 65);
			this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(133, 17);
			this.label2.TabIndex = 4;
			this.label2.Text = "Fail to retry interval:";
			// 
			// Form1
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(696, 591);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.lblStatus);
			this.Controls.Add(this.txtLog);
			this.Controls.Add(this.btnStart);
			this.Controls.Add(this.btnExit);
			this.Controls.Add(this.btnRefresh);
			this.Controls.Add(this.btnStop);
			this.Name = "Form1";
			this.Text = "Active Game Score provide (1.0)";
			this.Load += new System.EventHandler(this.Form1_Load);
			this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnStop;
		private System.Windows.Forms.Button btnStart;
		private System.Windows.Forms.Button btnExit;
		private System.Windows.Forms.Label lblStatus;
		private System.Windows.Forms.Label label1;
		public System.Windows.Forms.TextBox txtLog;
		private System.Windows.Forms.CheckBox checkBox1;
		private System.Windows.Forms.Button btnRefresh;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtInterval;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtTimeout;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
		private System.Windows.Forms.CheckBox chkRun;
    }
}

