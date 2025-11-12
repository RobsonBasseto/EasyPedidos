// Helpers/EnumToBoolWithDescriptionConverter.cs
using System;
using System.Globalization;
using Microsoft.Maui.Controls;

namespace EasyPedidos.Helpers
{
    public class EnumToBoolWithDescriptionConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is not Enum enumValue || parameter is not string param)
                return false;

            var enumParam = Enum.Parse(enumValue.GetType(), param);
            return enumValue.Equals(enumParam);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is true && parameter is string param)
            {
                return Enum.Parse(targetType, param);
            }
            return Binding.DoNothing;
        }

        // Para exibir o Description no Content
        public static string GetDescription(Enum value)
        {
            var field = value.GetType().GetField(value.ToString());
            var attribute = field?.GetCustomAttributes(typeof(System.ComponentModel.DescriptionAttribute), false)
                                .FirstOrDefault() as System.ComponentModel.DescriptionAttribute;
            return attribute?.Description ?? value.ToString();
        }
    }
}