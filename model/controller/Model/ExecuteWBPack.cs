using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class ExecuteWBPack
    {
        [JsonProperty("alu")]
        public ExecuteWBOPInfo[]? ALU { get; set; }
        [JsonProperty("bru")]
        public ExecuteWBOPInfo[]? BRU { get; set; }
        [JsonProperty("csr")]
        public ExecuteWBOPInfo[]? CSR { get; set; }
        [JsonProperty("div")]
        public ExecuteWBOPInfo[]? DIV { get; set; } 
        [JsonProperty("lsu")]
        public ExecuteWBOPInfo[]? LSU { get; set; }
        [JsonProperty("mul")]
        public ExecuteWBOPInfo[]? MUL { get; set; }
    }
}
