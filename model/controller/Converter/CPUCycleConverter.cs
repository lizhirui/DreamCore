using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace MyRISC_VCore_Model_GUI.Converter
{
    public class CPUCycleConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if(value is null)
            {
                throw new ArgumentNullException("value is null");
            }

            if(!(value is int))
            {
                throw new ArgumentException("value isn't int");
            }

            return "Cycle: " + ((int)value); 
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
