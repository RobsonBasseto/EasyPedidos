using System.Globalization;

namespace EasyPedidos.Helpers
{
    public class InverseBoolToColorConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool isMesa && parameter is string colors)
            {
                var parts = colors.Split(',');
                return !isMesa ? Color.FromArgb(parts[0]) : Color.FromArgb(parts[1]);
            }
            return Color.FromArgb("#555");
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value is bool boolValue ? !boolValue : false;
        }
    }
}