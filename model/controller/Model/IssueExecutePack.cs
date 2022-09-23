using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class IssueExecutePack
    {
        [JsonProperty("alu")]
        public IssueExecuteOPInfo[]?[]? ALU { get; set; }
        [JsonProperty("bru")]
        public IssueExecuteOPInfo[]?[]? BRU { get; set; }
        [JsonProperty("csr")]
        public IssueExecuteOPInfo[]?[]? CSR { get; set; }
        [JsonProperty("div")]
        public IssueExecuteOPInfo[]?[]? DIV { get; set; } 
        [JsonProperty("lsu")]
        public IssueExecuteOPInfo[]?[]? LSU { get; set; } 
        [JsonProperty("mul")]
        public IssueExecuteOPInfo[]?[]? MUL { get; set; } 
    }
}
