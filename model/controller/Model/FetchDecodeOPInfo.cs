using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class FetchDecodeOPInfo
    {
        [JsonProperty("pc")]
        public uint PC { get; set; }
        [JsonProperty("value")]
        public uint Value { get; set; }
        [JsonProperty("enable")]
        public bool Enable { get; set; }
        [JsonProperty("has_exception")]
        public bool HasException { get; set; }
        [JsonProperty("exception_id")]
        public string? ExceptionID { get; set; }
        [JsonProperty("exception_value")]
        public uint ExceptionValue { get; set; }
        [JsonProperty("predicted")]
        public bool Predicted { get; set; }
        [JsonProperty("predicted_jump")]
        public bool PredictedJump { get; set; }
        [JsonProperty("predicted_next_pc")]
        public uint PredictedNextPC { get; set; }
        [JsonProperty("checkpoint_id_valid")]
        public bool CheckpointIDValid { get; set; }
        [JsonProperty("checkpoint_id")]
        public uint CheckpointID { get; set; }

        public string Instruction = "<Empty>";
    }
}
