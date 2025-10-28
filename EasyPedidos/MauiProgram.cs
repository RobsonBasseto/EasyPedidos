using EasyPedidos.ViewModels;
using EasyPedidos.Pages;

namespace EasyPedidos
{
    public static class MauiProgram
    {
        public static MauiApp CreateMauiApp()
        {
            var builder = MauiApp.CreateBuilder();
            builder
                .UseMauiApp<App>()
                .ConfigureFonts(fonts =>
                {
                    fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                });

            // ViewModels
            builder.Services.AddTransient<PedidoViewModel>();
            builder.Services.AddTransient<ListPedidoViewModel>();
            builder.Services.AddTransient<DetalhesPedidoViewModel>();
            builder.Services.AddTransient<EditarPedidoViewModel>();

            // Pages
            builder.Services.AddTransient<PedidoPage>();
            builder.Services.AddTransient<ListPedidoPage>();
            builder.Services.AddTransient<DetalhesPedidoPage>();
            builder.Services.AddTransient<EditarPedidoPage>();

            return builder.Build();
        }
    }
}