using System.Globalization;

namespace EasyPedidos.Helpers
{
    public class BoolToOpacityConverter : IValueConverter
    {
        public object Convert(object value, Type t, object p, CultureInfo c)
            => (bool)value ? 1.0 : 0.0;

        public object ConvertBack(object value, Type t, object p, CultureInfo c) => throw new NotImplementedException();
    }
}