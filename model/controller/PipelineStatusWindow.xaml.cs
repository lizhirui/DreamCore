using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
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
    public partial class PipelineStatusWindow : Window
    {
        private static PipelineStatusWindow? instance = null;
        private MainWindow mainWindow;
        private Model.PipelineStatus? pipelineStatus = null;

        private PipelineStatusWindow(MainWindow mainWindow)
        {
            InitializeComponent();
            this.mainWindow = mainWindow;
            this.mainWindow.PipelineStatusReceivedEvent += MainWindow_PipelineStatusReceived;

            if(int.TryParse(Config.Get("PipelineStatus_Left", ""), out var left) && int.TryParse(Config.Get("PipelineStatus_Top", ""), out var top))
            {
                Left = left;
                Top = top;
            }
        }

        ~PipelineStatusWindow()
        {
            this.mainWindow.PipelineStatusReceivedEvent -= MainWindow_PipelineStatusReceived;
        }

        public static PipelineStatusWindow CreateInstance(MainWindow mainWindow)
        {
            if(instance == null)
            {
                instance = new PipelineStatusWindow(mainWindow);
                instance.Show();
            }

            return instance;
        }

        private void MainWindow_PipelineStatusReceived(Model.PipelineStatus PipelineStatus)
        {
            this.pipelineStatus = PipelineStatus;
            updateInstruction();
            refreshDisplay();
        }

        private string getInstructionText(uint Value, uint PC)
        {
            var result = RISC_V_Disassembler.Disassemble(BitConverter.GetBytes(Value), PC);
            return ((result != null) && (result.Length > 0)) ? (result[0].mnemonic + " " + result[0].op_str) : "<Invalid>";
        }

        private void updateInstruction()
        {
            if(pipelineStatus != null)
            {
                for(var i = 0;i < pipelineStatus.FetchDecode?.Length;i++)
                {
                    var item = pipelineStatus.FetchDecode[i];

                    if(item.Enable)
                    {
                        item.Instruction = getInstructionText(item.Value, item.PC);
                    }
                }

                for(var i = 0;i < pipelineStatus.DecodeRename?.Length;i++)
                {
                    var item = pipelineStatus.DecodeRename[i];

                    if(item.Enable)
                    {
                        item.Instruction = getInstructionText(item.Value, item.PC);
                    }
                }

                for(var i = 0;i < pipelineStatus.RenameReadreg?.Length;i++)
                {
                    var item = pipelineStatus.RenameReadreg[i];

                    if(item.Enable)
                    {
                        item.Instruction = getInstructionText(item.Value, item.PC);
                    }
                }

                for(var i = 0;i < pipelineStatus.ReadregIssue?.Length;i++)
                {
                    var item = pipelineStatus.ReadregIssue[i];

                    if(item.Enable)
                    {
                        item.Instruction = getInstructionText(item.Value, item.PC);
                    }
                }

                for(var i = 0;i < pipelineStatus.Issue?.Length;i++)
                {
                    var item = pipelineStatus.Issue[i];

                    if(item.Enable)
                    {
                        item.Instruction = getInstructionText(item.Value, item.PC);
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.ALU?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.ALU[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.BRU?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.BRU[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.CSR?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.CSR[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.DIV?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.DIV[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.LSU?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.LSU[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.IssueExecute?.MUL?.Length;i++)
                {
                    var item = pipelineStatus.IssueExecute.MUL[i];

                    for(var j = 0;j < item?.Length;j++)
                    {
                        if(item[j].Enable)
                        {
                            item[j].Instruction = getInstructionText(item[j].Value, item[j].PC);
                        }
                    }
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.ALU?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.ALU[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.BRU?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.BRU[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.CSR?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.CSR[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.DIV?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.DIV[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.LSU?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.LSU[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ExecuteWB?.MUL?.Length;i++)
                {
                    var item = pipelineStatus.ExecuteWB.MUL[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.WBCommit?.Length;i++)
                {
                    var item = pipelineStatus.WBCommit[i];
                    item.Instruction = getInstructionText(item.Value, item.PC);
                }

                for(var i = 0;i < pipelineStatus.ROB?.Length;i++)
                {
                    var item = pipelineStatus.ROB[i];
                    item.Instruction = getInstructionText(item.InstValue, item.PC);
                }
            }
        }

        private string getDisplayText(string instruction, uint pc)
        {
            if(instruction == "<Empty>")
            {
                return instruction;
            }
            else
            {
                return "0x" + string.Format("{0:X8}", pc) + ":" + instruction;
            }
        }

        #pragma warning disable CS8602
        private void refreshDisplay()
        {
            if(pipelineStatus != null)
            {
                label_Fetch.Content = "PC = 0x" + string.Format("{0:X8}", pipelineStatus.Fetch?.PC) + " jump__wait = " + pipelineStatus.Fetch?.JumpWait;
                
                listView_Fetch_Decode.Items.Clear();

                for(var i = 0;i < pipelineStatus.FetchDecode.Length;i++)
                {
                    var item = pipelineStatus.FetchDecode[i];
                    listView_Fetch_Decode.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Decode_Rename.Items.Clear();

                for(var i = 0;i < pipelineStatus.DecodeRename.Length;i++)
                {
                    var item = pipelineStatus.DecodeRename[i];
                    listView_Decode_Rename.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Rename_Readreg.Items.Clear();

                for(var i = 0;i < pipelineStatus.RenameReadreg.Length;i++)
                {
                    var item = pipelineStatus.RenameReadreg[i];
                    listView_Rename_Readreg.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Readreg_Issue.Items.Clear();

                for(var i = 0;i < pipelineStatus.RenameReadreg.Length;i++)
                {
                    var item = pipelineStatus.ReadregIssue[i];
                    listView_Readreg_Issue.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_IssueQueue.Items.Clear();

                for(var i = 0;i < pipelineStatus.Issue?.Length;i++)
                {
                    var item = pipelineStatus.Issue[i];
                    listView_IssueQueue.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Issue_Execute_ALU0.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.ALU[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_ALU0.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_ALU1.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.ALU[1];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_ALU1.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_BRU.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.BRU[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_BRU.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_CSR.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.CSR[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_CSR.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_DIV.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.DIV[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_DIV.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_LSU.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.LSU[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_LSU.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_MUL0.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.MUL[0];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_MUL0.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Issue_Execute_MUL1.Items.Clear();
                
                {
                    var item = pipelineStatus.IssueExecute.MUL[1];

                    for(var j = 0;j < item.Length;j++)
                    {
                        listView_Issue_Execute_MUL1.Items.Add(new{Highlight = false, Value = getDisplayText(item[j].Instruction, item[j].PC)});
                    }
                }

                listView_Execute_WB_ALU0.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.ALU[0];
                    listView_Execute_WB_ALU0.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_ALU1.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.ALU[1];
                    listView_Execute_WB_ALU1.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_BRU.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.BRU[0];
                    listView_Execute_WB_BRU.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_CSR.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.CSR[0];
                    listView_Execute_WB_CSR.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_DIV.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.DIV[0];
                    listView_Execute_WB_DIV.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_LSU.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.LSU[0];
                    listView_Execute_WB_LSU.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_MUL0.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.MUL[0];
                    listView_Execute_WB_MUL0.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_Execute_WB_MUL1.Items.Clear();

                {
                    var item = pipelineStatus.ExecuteWB.MUL[1];
                    listView_Execute_WB_MUL1.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                listView_WB_Commit.Items.Clear();

                for(var i = 0;i < pipelineStatus.WBCommit.Length;i++)
                {
                    var item = pipelineStatus.WBCommit[i];
                    listView_WB_Commit.Items.Add(new{Highlight = false, Value = getDisplayText(item.Instruction, item.PC)});
                }

                label_Issue_Feedback.Content = "stall = " + pipelineStatus.IssueFeedback.Stall;
                
                var wb_feedback_num = 0;

                foreach(var item in pipelineStatus.WBFeedback)
                {
                    if(item.Enable)
                    {
                        wb_feedback_num++;
                    }
                }
                
                button_WB_Feedback.Content = (wb_feedback_num == 0) ? "no feedback" : "" + wb_feedback_num + " feedback(s)";
                button_Commit_Feedback.Content = !pipelineStatus.CommitFeedback.Enable ? "no feedback" : ("next_handle_rob_id = " + pipelineStatus.CommitFeedback.NextHandleROBId + " has_exception = " + pipelineStatus.CommitFeedback.HasException);

                listView_ROB.Items.Clear();

                for(var i = 0;i < pipelineStatus.ROB.Length;i++)
                {
                    var item = pipelineStatus.ROB[i];
                    listView_ROB.Items.Add(new{Highlight = false, Value = item.ROBID + ":" + getDisplayText(item.Instruction, item.PC) + "(" + (item.Finish ? "Finished" : "Unfinish") + ")"});
                }
            }
        }
        #pragma warning restore CS8602

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Maximized;
        }
        private void Window_Closed(object sender, EventArgs e)
        {
            PipelineStatusWindow.instance = null;
        }
        private void Window_LocationChanged(object sender, EventArgs e)
        {
            Config.Set("PipelineStatus_Left", "" + Left);
            Config.Set("PipelineStatus_Top", "" + Top);
        }

        #pragma warning disable CS8602
        private void HighlightROBItem(uint robID, bool highlight)
        {
            for(var i = 0;i < listView_ROB.Items.Count;i++)
            {
                var item = (dynamic)listView_ROB.Items[i];

                if(item.Highlight ^ ((pipelineStatus?.ROB?[i].ROBID == robID) && highlight))
                {
                    listView_ROB.Items[i] = new{Highlight = (pipelineStatus?.ROB?[i].ROBID == robID) && highlight, Value = item.Value};
                }
            }
        }

        private void DisplayDetail(object? obj)
        {
            #pragma warning disable CS8601
            #pragma warning disable CS8625
            objectInTreeView_Detail.ObjectToVisualize = null;
            objectInTreeView_Detail.ObjectToVisualize = obj;
            #pragma warning restore CS8601
            #pragma warning restore CS8625
        }

        private void listView_Fetch_Decode_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            var list = sender as ListView;
            var id = list.SelectedIndex;

            if(id >= 0)
            {
                HighlightROBItem(0, false);
                DisplayDetail(pipelineStatus.FetchDecode[id]);
            }
        }

        private void listView_Decode_Rename_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            var list = sender as ListView;
            var id = list.SelectedIndex;

            if(id >= 0)
            {
                HighlightROBItem(0, false);
                DisplayDetail(pipelineStatus.DecodeRename[id]);
            }
        }

        private void listView_Rename_Readreg_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.RenameReadreg[id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Readreg_Issue_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ReadregIssue[id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_IssueQueue_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.Issue[id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_ALU0_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.ALU[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_ALU1_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.ALU[1][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_BRU_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.BRU[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_CSR_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.CSR[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_DIV_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.DIV[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_LSU_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.LSU[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_MUL0_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.MUL[0][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Issue_Execute_MUL1_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.IssueExecute.MUL[1][id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_ALU0_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.ALU[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_ALU1_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.ALU[1];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_BRU_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.BRU[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_CSR_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.CSR[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_DIV_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.DIV[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_LSU_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.LSU[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_MUL0_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.MUL[0];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_Execute_WB_MUL1_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ExecuteWB.MUL[1];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_WB_Commit_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.WBCommit[id];
                    HighlightROBItem(item.ROBID, true);
                    DisplayDetail(item);
                }
            }
            catch
            {
                HighlightROBItem(0, false);
                DisplayDetail(null);
            }
        }

        private void listView_ROB_PreviewMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            try
            {
                var list = sender as ListView;
                var id = list.SelectedIndex;

                if(id >= 0)
                {
                    var item = pipelineStatus.ROB[id];
                    DisplayDetail(item);
                }
            }
            catch
            {
                DisplayDetail(null);
            }
        }

        private void button_WB_Feedback_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var item = pipelineStatus.WBFeedback;
                DisplayDetail(item);
            }
            catch
            {
                DisplayDetail(null);
            }
        }

        private void button_Commit_Feedback_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var item = pipelineStatus.CommitFeedback;
                DisplayDetail(item);
            }
            catch
            {
                DisplayDetail(null);
            }
        }
        #pragma warning restore CS8602
    }
}
