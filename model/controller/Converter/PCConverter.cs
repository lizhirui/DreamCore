using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace MyRISC_VCore_Model_GUI.Converter
{
    public class PCConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if(value is null)
            {
                throw new ArgumentNullException("value is null");
            }

            if(!(value is uint))
            {
                throw new ArgumentException("value isn't int");
            }

            return "PC: 0x" + string.Format("{0:X8}", (uint)value); 
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
