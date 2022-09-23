using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;

namespace TreeViewMagic
{
    #pragma warning disable CS8600
    #pragma warning disable CS8601
    #pragma warning disable CS8602
    #pragma warning disable CS8603
    #pragma warning disable CS8604
    #pragma warning disable CS8618
    public class TreeNode
    {
        public string Name { get; set; }
        public string Value { get; set; }
        public List<TreeNode> Children { get; set; } = new List<TreeNode>();
 
        public static TreeNode CreateTree(object? obj)
        {
            /*var serialized = Newtonsoft.Json.JsonConvert.SerializeObject(obj);

            try
            {
                Dictionary<string, object> dic = System.Text.Json.JsonSerializer.Deserialize<Dictionary<string, object>>(serialized);
                var root = new TreeNode();
                root.Name = "Root";
                BuildTree(dic, root);
                return root;
            }
            catch
            {
                ArrayList dic = System.Text.Json.JsonSerializer.Deserialize<ArrayList>(serialized);
                var root = new TreeNode();
                root.Name = "Root";
                BuildTree(dic, root);
                return root;
            }*/
            var root = new TreeNode();
            root.Name = "Root";

            if(obj != null)
            {
                BuildTree(obj, root);
            }
            
            return root;
        }
 
        private static void BuildTree(object item, TreeNode node)
        {
            if(item is object[])
            {
                List<object> list = (item as object[]).ToList();
                var index = 0;

                foreach(var value in list)
                {
                    var arrayItem = new TreeNode();
                    arrayItem.Name = $"[{index}]";
                    arrayItem.Value = "";
                    node.Children.Add(arrayItem);
                    BuildTree(value, arrayItem);
                    index++;
                }
            }
            else
            {
                foreach(var prop in item.GetType().GetProperties())
                {
                    var propItem = new TreeNode();
                    propItem.Name = prop.Name;
                    var value = prop.GetValue(item);
                    
                    if(value is object[])
                    {
                        BuildTree(value, propItem);
                    }
                    else
                    {
                        propItem.Value = getValueString(value);
                    }

                    node.Children.Add(propItem);
                }

                foreach(var member in item.GetType().GetMembers())
                {
                    if(member.Name == "Instruction")
                    {
                        var memberItem = new TreeNode();
                        memberItem.Name = member.Name;
                        var value = (member as FieldInfo).GetValue(item);
                        memberItem.Value = getValueString(value);
                        node.Children.Add(memberItem);
                    }
                }
            }
        }
 
        private static string getValueString(object value)
        {
            if(value is string)
            {
                return value as string;
            }
            else if(value is uint)
            {
                return "0x" + string.Format("{0:X8}", (uint)value) + "(" + ((uint)value) + ")";
            }
            else
            {
                return value + "";
            }
        }
    }
}
