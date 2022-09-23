using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class PipelineStatus
    {
        [JsonProperty("fetch")]
        public Fetch? Fetch { get; set; }
        [JsonProperty("fetch_decode")]
        public FetchDecodeOPInfo[]? FetchDecode { get; set; }
        [JsonProperty("decode_rename")]
        public DecodeRenameOPInfo[]? DecodeRename { get; set; }
        [JsonProperty("rename_readreg")]
        public RenameReadregOPInfo[]? RenameReadreg { get; set; }
        [JsonProperty("readreg_issue")]
        public ReadregIssueOPInfo[]? ReadregIssue { get; set; }
        [JsonProperty("issue")]
        public IssueOPInfo[]? Issue { get; set; }
        [JsonProperty("issue_execute")]
        public IssueExecutePack? IssueExecute { get; set; }
        [JsonProperty("execute_wb")]
        public ExecuteWBPack? ExecuteWB { get; set; }
        [JsonProperty("wb_commit")]
        public WBCommitOPInfo[]? WBCommit { get; set; }
        [JsonProperty("issue_feedback_pack")]
        public IssueFeedback? IssueFeedback { get; set; }
        [JsonProperty("wb_feedback_pack")]
        public WBFeedback[]? WBFeedback { get; set; }
        [JsonProperty("commit_feedback_pack")]
        public CommitFeedback? CommitFeedback { get; set; }
        [JsonProperty("rob")]
        public ROBItem[]? ROB { get; set; }
    }
}
