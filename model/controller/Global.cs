using MyRISC_VCore_Model_GUI.DataSource;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;

namespace MyRISC_VCore_Model_GUI
{
    public static class Global
    {
        public static ValueDataSource<bool> connected = false;
        public static TcpClient? conn = null;
        public static Thread? recvThread = null;
        public static Thread? recvHandleThread = null;
        public static ConcurrentQueue<string> recvQueue = new ConcurrentQueue<string>();
        private static bool recvThreadClose = false;
        private static bool recvHandleThreadClose = false;

        public static ValueDataSource<bool> running = false;
        public static ValueDataSource<int> cpuCycle = 0;
        public static ValueDataSource<uint> pc = 0;

        public delegate void CommandReceivedHandler(string prefix, string cmd, string result);
        public static event CommandReceivedHandler? CommandReceivedEvent;

        public static void Error(string message)
        {
            MessageBox.Show(message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
        }

        public static bool SendCommand(string prefix, string cmd, bool ignoreRunning = false)
        {
            if(!connected)
            {
                return false;
            }

            if(conn == null)
            {
                return false;
            }

            if(running && (cmd != "pause") && (!ignoreRunning))
            {
                return false;
            }

            var str = prefix + " " + cmd;
            var bytes = Encoding.UTF8.GetBytes(str);
            var send_bytes = Encoding.Convert(Encoding.UTF8, Encoding.GetEncoding("GB2312"), bytes);
            var stream = conn.GetStream();
            stream.Write(BitConverter.GetBytes((uint)send_bytes.Length), 0, 4);
            stream.Write(send_bytes, 0, send_bytes.Length);
            return true;
        }

        public static void StartRecv()
        {
            recvThreadClose = false;
            recvThread = new Thread(RecvThreadEntry);
            recvThread.IsBackground = true;
            recvThread.Start();
            recvHandleThreadClose = false;
            recvHandleThread = new Thread(RecvHandleThreadEntry);
            recvHandleThread.IsBackground = true;
            recvHandleThread.Start();
        }

        public static void StopRecv()
        {
            if(recvHandleThread != null)
            {
                recvHandleThreadClose = true;
                recvHandleThread.Join();
                recvHandleThread = null;
            }

            if(recvThread != null)
            {
                recvThreadClose = true;
                recvThread.Join();
                recvThread = null;
            }
        }

        private static void RecvHandleThreadEntry()
        {
            while(!recvHandleThreadClose)
            {
                try
                {
                    if(!recvQueue.IsEmpty)
                    {
                        var packet = "";

                        if(recvQueue.TryDequeue(out packet))
                        {
                            var cmdArgList = packet.Split(' ');
                            var prefix = cmdArgList[0];
                            var cmd = cmdArgList[1];
                            var result = packet.Substring(prefix.Length + cmd.Length + 2);
                            CommandReceivedEvent?.Invoke(prefix, cmd, result);
                        }
                    }
                    else
                    {
                        Thread.Sleep(10);
                    }
                }
                catch
                {
                }
            }
        }

        private static void RecvThreadEntry()
        {
            var revLength = 0;
            byte[]? packetPayload = null;
            byte[] packetLength = new byte[4];

            while(!recvThreadClose)
            {
                try
                {
                    if((conn != null) && (connected))
                    {
                        var stream = conn.GetStream();
                        stream.ReadTimeout = 1000;
                        
                        if(packetPayload == null)
                        {
                            revLength += stream.Read(packetLength, revLength, packetLength.Length - revLength);
                            var finish = revLength == packetLength.Length;

                            if(finish)
                            {
                                var length = BitConverter.ToInt32(packetLength);

                                if(length > 0)
                                {
                                    packetPayload = new byte[length];
                                    revLength = 0;
                                }
                            }
                        }
                        else
                        {
                            revLength += stream.Read(packetPayload, revLength, packetPayload.Length - revLength);
                            var finish = revLength == packetPayload.Length;

                            if(finish)
                            {
                                var str = Encoding.UTF8.GetString(Encoding.Convert(Encoding.GetEncoding("GB2312"), Encoding.UTF8, packetPayload));
                                recvQueue.Enqueue(str);
                                packetPayload = null;
                                revLength = 0;
                            }
                        }
                    }
                }
                catch(IOException)
                {
                    
                }
                catch
                {
                    connected.Value = false;
                }
            }
        }
    }
}
