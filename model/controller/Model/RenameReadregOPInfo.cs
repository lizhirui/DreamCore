using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace MyRISC_VCore_Model_GUI.Model
{
    [Serializable]
    public class RenameReadregOPInfo
    {
        [JsonProperty("enable")]
        public bool Enable { get; set; }
        [JsonProperty("valid")]
        public bool Valid { get; set; }
        [JsonProperty("value")]
        public uint Value { get; set; }
        [JsonProperty("rob_id")]
        public uint ROBID { get; set; }
        [JsonProperty("pc")]
        public uint PC { get; set; }
        [JsonProperty("imm")]
        public uint Imm { get; set; }
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
        [JsonProperty("rs1")]
        public uint RS1 { get; set; }
        [JsonProperty("arg1_src")]
        public string? Arg1Src { get; set; }
        [JsonProperty("rs1_need_map")]
        public bool RS1NeedMap { get; set; }
        [JsonProperty("rs1_phy")]
        public uint RS1Phy { get; set; }
        [JsonProperty("rs2")]
        public uint RS2 { get; set; }
        [JsonProperty("arg2_src")]
        public string? Arg2Src { get; set; }
        [JsonProperty("rs2_need_map")]
        public bool RS2NeedMap { get; set; }
        [JsonProperty("rs2_phy")]
        public uint RS2Phy { get; set; }
        [JsonProperty("rd")]
        public uint RD { get; set; }
        [JsonProperty("rd_enable")]
        public bool RDEnable { get; set; }
        [JsonProperty("need_rename")]
        public bool NeedRename { get; set; }
        [JsonProperty("rd_phy")]
        public uint RDPhy { get; set; }
        [JsonProperty("csr")]
        public uint CSR { get; set; }
        [JsonProperty("op")]
        public string? OP { get; set; }
        [JsonProperty("op_unit")]
        public string? OPUnit { get; set; }
        [JsonProperty("sub_op")]
        public string? SubOP { get; set; }

        public string Instruction = "<Empty>";
    }
}
