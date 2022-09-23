using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace MyRISC_VCore_Model_GUI
{
    /// <summary>
    /// ConnectionConfig.xaml 的交互逻辑
    /// </summary>
    public partial class ConnectionConfig : Window
    {
        public ConnectionConfig()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            textBox_Server.Text = Config.Get("server", "127.0.0.1");
            textBox_Port.Text = Config.Get("port", "10240");
        }

        private void button_Connect_Click(object sender, RoutedEventArgs e)
        {
            var server = textBox_Server.Text.Trim();
            var port = 0;

            try
            {
                port = int.Parse(textBox_Port.Text.Trim());
            }
            catch
            {
                Global.Error("Invalid port!");
            }

            if(Global.conn != null)
            {
                Global.StopRecv();
                Global.conn.Close();
                Global.conn = null;
            }

            Global.conn = new TcpClient();

            try
            {
                Global.conn.Connect(server, port);
            }
            catch
            {
                Global.Error("Connect Failed!");
            }

            Global.connected.Value = Global.conn.Connected;

            if(Global.conn.Connected)
            {
                Global.conn.ReceiveBufferSize = 102400;
                Global.conn.SendBufferSize = 102400;
                Global.conn.NoDelay = true;
                Global.StartRecv();
                Config.Set("server", server);
                Config.Set("port", "" + port);
                Close();
            }
        }

        private void button_disConnnect_Click(object sender, RoutedEventArgs e)
        {
            if(Global.conn != null)
            {
                Global.StopRecv();
                Global.conn.Close();
                Global.conn = null;
            }

            Global.connected.Value = false;
            Close();
        }
    }
}
