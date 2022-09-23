using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyRISC_VCore_Model_GUI.DataSource
{
    public class ValueDataSource<T> : INotifyPropertyChanged where T : struct
    {
        public event PropertyChangedEventHandler? PropertyChanged;
        private T _value = default;

        public T Value
        {
            get
            {
                return _value;
            }

            set
            {
                _value = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs("Value"));
            }
        }
        
        ValueDataSource(T value)
        {
            Value = value;
        }

        public static implicit operator ValueDataSource<T>(T v)
        {
            return new ValueDataSource<T>(v);
        }

        public static implicit operator T(ValueDataSource<T> v)
        {
            return v.Value;
        }
    }
}
