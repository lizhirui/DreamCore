using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyRISC_VCore_Model_GUI
{
    class HTMLConstructor
    {
        private StringBuilder stb = new StringBuilder();
        private string tabSpace = "    ";
        private string curLineTab = "";
        private bool newLine = true;
        private Stack<string> labelStack = new Stack<string>();

        public void AddTabLevel()
        {
            curLineTab += tabSpace;
        }

        public void SubTabLevel()
        {
            curLineTab = curLineTab.Substring(0,curLineTab.Length - tabSpace.Length);
        }

        public void Append(string str)
        {
            if(newLine)
            {
                stb.Append(curLineTab);
                newLine = false;
            }

            stb.Append(str);
        }

        public void AppendLine(string str)
        {
            stb.AppendLine(str);
            newLine = true;
        }

        public void AddHTMLStartLabel(string name,string param)
        {
            AppendLine($"<{name}{(param.Length > 0 ? $" {param}" : "")}>");
            AddTabLevel();
            labelStack.Push(name);
        }

        public void AddHTMLStartLabel(string name)
        {
            AddHTMLStartLabel(name,"");
        }

        public void AddHTMLEndLabel(string name)
        {
            SubTabLevel();
            AppendLine("</" + name + ">");

            if(labelStack.Count == 0)
            {
                throw new ArgumentException("Couldn't find corresponding start label for " + name + "!");
            }

            if(labelStack.Peek() != name)
            {
                throw new ArgumentException(labelStack.Peek() + "isn't match with " + name + "!");
            }

            labelStack.Pop();
        }

        public void AddHTMLLabel(string name,string param)
        {
            AppendLine($"<{name}{(param.Length > 0 ? $" {param}" : "")} />");
        }

        public void AddHTMLLabel(string name)
        {
            AddHTMLLabel(name,"");
        }

        public void Clear()
        {
            stb.Clear();
            labelStack.Clear();
        }

        public int Length
        {
            get
            {
                return stb.Length;
            }
        }

        public override string ToString()
        {
            if(labelStack.Count != 0)
            {
                throw new ArgumentException("Unclosed label " + labelStack.Peek());
            }

            return stb.ToString();
        }
    }
}
