using System.Globalization;

namespace EasyPedidos.Helpers
{
    public class EnumToDescriptionConverter : IValueConverter
    {
        public static EnumToDescriptionConverter Instance { get; } = new();

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is Enum enumValue)
            {
                return enumValue.GetDescription();
            }
            return value?.ToString() ?? string.Empty;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }

}