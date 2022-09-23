using MyRISC_VCore_Model_GUI.DataSource;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;
using System.Windows.Media;

namespace MyRISC_VCore_Model_GUI.Converter
{
    class RunningStatusColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if(value == null)
            {
                throw new ArgumentNullException("value is null");
            }

            if(!(value is bool) && !(value is ValueDataSource<bool>))
            {
                throw new ArgumentException("value isn't bool");
            }

            var v = (value is ValueDataSource<bool>) ? (bool)(ValueDataSource<bool>)value : (bool)value;
            return v ? Brushes.Green : Brushes.Red;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
