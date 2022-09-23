using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class IssueFeedback
    {
        [JsonProperty("stall")]
        public bool Stall { get; set; }
    }
}
