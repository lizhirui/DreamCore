using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class CommitFeedback
    {
        [JsonProperty("enable")]
        public bool Enable { get; set; }
        [JsonProperty("next_handle_rob_id_valid")]
        public bool NextHandleROBIdValid { get; set; }
        [JsonProperty("next_handle_rob_id")]
        public uint NextHandleROBId { get; set; }
        [JsonProperty("committed_rob_id_valid_0")]
        public bool CommittedROBIdValid0 { get; set; }
        [JsonProperty("committed_rob_id_0")]
        public uint CommittedROBId0 { get; set; }
        [JsonProperty("committed_rob_id_valid_1")]
        public bool CommittedROBIdValid1 { get; set; }
        [JsonProperty("committed_rob_id_1")]
        public uint CommittedROBId1 { get; set; }
        [JsonProperty("has_exception")]
        public bool HasException { get; set; }
        [JsonProperty("exception_pc")]
        public uint ExceptionPC { get; set; }
        [JsonProperty("flush")]
        public bool Flush { get; set; }
        [JsonProperty("jump_enable")]
        public bool JumpEnable { get; set; }
        [JsonProperty("jump")]
        public bool Jump { get; set; }
        [JsonProperty("next_pc")]
        public uint NextPC { get; set; }
    }
}
