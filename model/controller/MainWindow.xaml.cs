using System;
using System.Collections.Generic;
using System.Linq;
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
using System.Windows.Navigation;
using System.Windows.Shapes;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public delegate void PipelineStatusReceivedHandler(Model.PipelineStatus PipelineStatus);
        public event PipelineStatusReceivedHandler? PipelineStatusReceivedEvent;
        public MainWindow()
        {
            InitializeComponent();
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            Global.CommandReceivedEvent += Global_CommandReceivedEvent;
            Global.connected.PropertyChanged += Connected_PropertyChanged;
            PipelineStatusWindow.CreateInstance(this);

            if(int.TryParse(Config.Get("MainWindow_Left", ""), out var left) && int.TryParse(Config.Get("MainWindow_Top", ""), out var top))
            {
                Left = left;
                Top = top;
            }
        }

        private void ConnectedEvent()
        {
            Global.SendCommand("main", "pause", true);
            Global.running.Value = true;
            refreshGlobalStatus(true);
        }

        private void Connected_PropertyChanged(object? sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if(Global.connected)
            {
                Dispatcher.BeginInvoke(() => ConnectedEvent());
            }
        }

        private void Continue_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            Global.SendCommand("main", "continue");
        }

        private void Pause_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            Global.SendCommand("main", "pause", true);
            refreshGlobalStatus(true);
        }

        private void StepCommit_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            Global.SendCommand("main", "stepcommit");
            refreshGlobalStatus();
        }

        private void Step_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            Global.SendCommand("main", "step");
            refreshGlobalStatus();
        }

        private void Reset_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            Global.SendCommand("main", "reset");
            refreshGlobalStatus();
        }
        
        private void CommandReceivedEvent(string prefix, string cmd, string result)
        {
            if(prefix == "log")
            {
                textBox_CommandLog.AppendText(cmd + ": " + result + "\n");
                textBox_CommandLog.ScrollToEnd();
            }

            switch(cmd)
            {
                case "read_memory":
                    if(prefix == "memory")
                    {
                        refreshMemory(result);
                    }
                    else
                    {
                        refreshInstruction(result);
                    }

                    break;

                case "read_archreg":
                    refreshArchRegister(result);
                    break;

                case "read_csr":
                    refreshCSR(result);
                    break;

                case "get_pc":
                    refreshPC(result);
                    break;

                case "get_cycle":
                    Global.cpuCycle.Value = int.Parse(result);
                    break;

                case "pause":
                    Global.running.Value = false;
                    break;

                case "continue":
                    Global.running.Value = true;
                    break;

                case "get_pipeline_status":
                    var pack = JsonConvert.DeserializeObject<Model.PipelineStatus>(result);

                    if(pack != null)
                    {
                        PipelineStatusReceivedEvent?.Invoke(pack);
                    }

                    break;
            }
        }

        private void refreshGlobalStatus(bool ignoreRunning = false)
        {
            Global.SendCommand("main", "read_memory 0x" + string.Format("{0:X8}", Global.pc & (~0xfff)) + " 4096", ignoreRunning);
            Global.SendCommand("main", "read_archreg", ignoreRunning);
            Global.SendCommand("main", "read_csr", ignoreRunning);
            Global.SendCommand("main", "get_pc", ignoreRunning);
            Global.SendCommand("main", "get_cycle", ignoreRunning);
            Global.SendCommand("main", "get_pipeline_status", ignoreRunning);
        }

        private List<byte> lastMemoryByteList = new List<byte>();
        public uint lastAddress = 0U;

        private void refreshMemory(string result)
        {
            var bytes_str = result.Trim().Split(',');
            var byte_list = new List<byte>();

            var address = Convert.ToUInt32(bytes_str[0], 16);

            for(var i = 1;i < bytes_str.Length;i++)
            {
                byte_list.Add(Convert.ToByte(bytes_str[i], 16));
            }

            if((address == lastAddress) && byte_list.SequenceEqual(lastMemoryByteList))
            {
                return;
            }

            lastAddress = address;
            lastMemoryByteList = byte_list;

            var byte_arr = byte_list.ToArray();

            listView_Memory.Items.Clear();
            listView_Memory.Items.Add(new{Address = "", Data = "00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F", Text="0123456789ABCDEF"});

            for(var i = 0;i < byte_list.Count;i += 16)
            {
                var data_str = new StringBuilder();
                var text_str = new StringBuilder();

                for(var j = 0;j < Math.Min(16, byte_list.Count - i);j++)
                {
                    data_str.Append(string.Format("{0:X2}", byte_list[i + j]) + " ");
                    text_str.Append(((byte_list[i + j] > 126) || (byte_list[i + j] < 32)) ? "." : Encoding.ASCII.GetString(byte_arr, i + j, 1));
                }

                listView_Memory.Items.Add(new{Address = string.Format("{0:X8}", (address + i)), Data = data_str, Text = text_str});
            }
        }

        private List<byte> lastInstByteList = new List<byte>();

        private void refreshInstruction(string result)
        {
            var bytes_str = result.Trim().Split(',');
            var byte_list = new List<byte>();

            var address = Convert.ToUInt32(bytes_str[0], 16);

            for(var i = 1;i < bytes_str.Length;i++)
            {
                byte_list.Add(Convert.ToByte(bytes_str[i], 16));
            }

            if(byte_list.SequenceEqual(lastInstByteList))
            {
                return;
            }

            lastInstByteList = byte_list;

            var inst_info = RISC_V_Disassembler.Disassemble(byte_list.ToArray(), address);
            listView_Instruction.Items.Clear();

            foreach(var item in inst_info)
            {
                var data_str = new StringBuilder();

                for(var i = 0;i < item.size;i++)
                {
                    if(i != 0)
                    {
                        data_str.Append(" ");
                    }

                    data_str.Append(string.Format("{0:X2}", item.bytes[i]));
                }

                listView_Instruction.Items.Add(new{Highlight = false, Status = "", Address = string.Format("{0:X8}", item.address), Data = data_str.ToString(), Instruction = item.mnemonic + " " + item.op_str});
            }
        }

        private List<uint> lastArchValueList = new List<uint>();

        private void refreshArchRegister(string result)
        {
            var reg_name = new string[]{"zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0/fp", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3",
                                        "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
            var value_str = result.Trim().Split(',');
            var value_list = new List<uint>();

            for(var i = 0;i < value_str.Length;i++)
            {
                value_list.Add(Convert.ToUInt32(value_str[i], 16));
            }

            if(value_list.SequenceEqual(lastArchValueList))
            {
                return;
            }

            if(lastArchValueList.Count != value_list.Count)
            {
                listView_ArchRegister.Items.Clear();

                for(var i = 0;i < value_list.Count;i++)
                {
                    var value = value_list[i];
                    listView_ArchRegister.Items.Add(new{Highlight = false, Name = "x" + i + "/" + reg_name[i], Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"});
                }
            }
            else
            {
                for(var i = 0;i < value_list.Count;i++)
                {
                    var item = (dynamic)listView_ArchRegister.Items[i];
                    var value = value_list[i];

                    if(value_list[i] != lastArchValueList[i])
                    {
                        listView_ArchRegister.Items[i] = new{Highlight = true, Name = item.Name, Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"};
                    }
                    else if(item.Highlight)
                    {
                        listView_ArchRegister.Items[i] = new{Highlight = false, Name = item.Name, Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"};
                    }
                }
            }

            lastArchValueList = value_list;
        }

        private List<string> lastCSRList = new List<string>();

        private void refreshCSR(string result)
        {
            var item_list = result.Split(",");

            var csr_list = new List<string>();

            foreach(var item in item_list)
            {
                var info = item.Split(":");

                if(info.Length == 2)
                {
                    csr_list.Add(item);
                }
            }

            if(lastCSRList.SequenceEqual(csr_list))
            {
                return;
            }

            if(lastCSRList.Count != csr_list.Count)
            {
                listView_CSR.Items.Clear();

                foreach(var item in item_list)
                {
                    var info = item.Split(":");

                    if(info.Length == 2)
                    {
                        var value = Convert.ToUInt32(info[1], 16);
                        listView_CSR.Items.Add(new{Highlight = false, Name = info[0], Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"});
                    }
                }
            }
            else
            {
                for(var i = 0;i < csr_list.Count;i++)
                {
                    var item = (dynamic)listView_CSR.Items[i];
                    var info = csr_list[i].Split(":");
                    var value = Convert.ToUInt32(info[1], 16);

                    if(csr_list[i] != lastCSRList[i])
                    {
                        listView_CSR.Items[i] = new{Highlight = true, Name = info[0], Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"};
                    }
                    else if(item.Highlight)
                    {
                        listView_CSR.Items[i] = new{Highlight = false, Name = info[0], Value = "0x" + string.Format("{0:X8}", value) + "(" + value + ")"};
                    }
                }
            }

            lastCSRList = csr_list;
        }

        private void refreshPC(string result)
        {
            var pc = Convert.ToUInt32(result, 16);
            var pc_item_index = -1;
            uint addr_min = 0xFFFFFFFFU;
            uint addr_max = 0u;

            for(var i = 0;i < listView_Instruction.Items.Count;i++)
            {
                var address = Convert.ToUInt32(((dynamic)listView_Instruction.Items[i]).Address, 16);
                var item = (dynamic)listView_Instruction.Items[i];

                addr_min = Math.Min(addr_min, address);
                addr_max = Math.Max(addr_max, address);

                if((pc == address) ^ (((dynamic)listView_Instruction.Items[i]).Status == "-->"))
                {
                    listView_Instruction.Items[i] = new{Status = (pc == address) ? "-->" : "", Highlight = pc == address, Address = item.Address, Data = item.Data, Instruction = item.Instruction};
                }

                if(pc == address)
                {
                    pc_item_index = i;   
                }
            }

            Global.pc.Value = pc;

            if((pc < addr_min) || (pc > addr_max))
            {
                refreshGlobalStatus(true);
            }

            if(pc_item_index >= 0)
            {
                listView_Instruction.ScrollIntoView(listView_Instruction.Items[pc_item_index]);
            }
        }

        private void Global_CommandReceivedEvent(string prefix, string cmd, string result)
        {
            Dispatcher.BeginInvoke(() => CommandReceivedEvent(prefix, cmd, result));
        }

        private void menuItem_File_Load_Click(object sender, RoutedEventArgs e)
        {

        }

        private void menuItem_System_Connect_Click(object sender, RoutedEventArgs e)
        {
            new ConnectionConfig().ShowDialog();
        }

        private void menuItem_Help_About_Click(object sender, RoutedEventArgs e)
        {

        }

        private string lastCmd = "";

        private void textBox_Command_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.Key == Key.Enter)
            {
                e.Handled = true;

                if(textBox_Command.Text != "")
                {
                    lastCmd = textBox_Command.Text;
                }

                if(Global.SendCommand("log", lastCmd))
                {
                    textBox_Command.Text = "";
                }
            }
        }

        private void textBox_MemoryAddress_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.Key == Key.Enter)
            {
                e.Handled = true;

                if(textBox_MemoryAddress.Text != "")
                {
                    try
                    {
                        var address_text = textBox_MemoryAddress.Text.Trim();

                        if(address_text.StartsWith("0x"))
                        {
                            address_text = address_text.Substring(2);
                        }

                        var address = Convert.ToUInt32(address_text, 16);
                        Global.SendCommand("memory", "read_memory 0x" + string.Format("{0:X8}", address) + " 1024");
                    }
                    catch
                    {
                        Global.Error("输入无效！");
                    }
                }
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Maximized;
        }

        private void Window_LocationChanged(object sender, EventArgs e)
        {
            Config.Set("MainWindow_Left", "" + Left);
            Config.Set("MainWindow_Top", "" + Top);
        }

        private void menuItem_Window_PipelineStatus_Click(object sender, RoutedEventArgs e)
        {
            PipelineStatusWindow.CreateInstance(this);
        }
    }
}
