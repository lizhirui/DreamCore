using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyRISC_VCore_Model_GUI
{
    public static class Config
    {
        public static string Get(string name, string defaultValue)
        {
            try
            {
                var ret = ConfigurationManager.AppSettings[name];

                if(ret == null)
                {
                    return defaultValue;
                }

                return ret.ToString();
            }
            catch
            {
                return defaultValue;
            }
        }

        public static void Set(string name, string value)
        {
            var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);

            if(ConfigurationManager.AppSettings[name] != null)
            {
                config.AppSettings.Settings.Remove(name);
            }

            config.AppSettings.Settings.Add(name, value);
            config.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection("appSettings");
        }
    }
}
