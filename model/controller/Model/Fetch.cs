using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class Fetch
    {
        [JsonProperty("pc")]
        public uint PC { get; set; }
        [JsonProperty("jump_wait")]
        public bool JumpWait { get; set; }
    }
}
