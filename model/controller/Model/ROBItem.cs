using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class ROBItem
    {
        [JsonProperty("rob_id")]
        public uint ROBID { get; set; }
        [JsonProperty("new_phy_reg_id")]
        public uint NewPhyRegID { get; set; }
        [JsonProperty("old_phy_reg_id")]
        public uint OldPhyRegID { get; set; }
        [JsonProperty("old_phy_reg_id_valid")]
        public bool OldPhyRegIDValid { get; set; }
        [JsonProperty("finish")]
        public bool Finish { get; set; }
        [JsonProperty("pc")]
        public uint PC { get; set; }
        [JsonProperty("inst_value")]
        public uint InstValue { get; set; }
        [JsonProperty("has_exception")]
        public bool HasException { get; set; }
        [JsonProperty("exception_id")]
        public string? ExceptionID { get; set; }
        [JsonProperty("exception_value")]
        public uint ExceptionValue { get; set; }

        public string Instruction = "";
    }
}
