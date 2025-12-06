using CommunityToolkit.Maui;
using EasyPedidos.Pages;
using EasyPedidos.ViewModels;
using Syncfusion.Maui.Core.Hosting; 

namespace EasyPedidos
{
    public static class MauiProgram
    {
        public static MauiApp CreateMauiApp()
        {
            var builder = MauiApp.CreateBuilder();
            builder
                .UseMauiApp<App>()
                .UseMauiCommunityToolkit()
                .ConfigureSyncfusionCore()
                .ConfigureFonts(fonts =>
                {
                    fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                });

            // SYNC FUSION LICENÇA (MESMO FREE)
            Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("Ngo9BigBOggjHTQxAR8/V1JFaF5cXGRCf1FpRmJGdld5fUVHYVZUTXxaS00DNHVRdkdmWH1edHRcQ2ZfU0RwWkVWYEg=");

            // REGISTRO DE VIEWMODELS E PAGES
            builder.Services.AddTransient<PedidoViewModel>();
            builder.Services.AddTransient<ListPedidoViewModel>();
            builder.Services.AddTransient<DetalhesPedidoViewModel>();
            builder.Services.AddTransient<EditarPedidoViewModel>();
            builder.Services.AddTransient<FinalizarPedidoViewModel>();

            builder.Services.AddTransient<PedidoPage>();
            builder.Services.AddTransient<ListPedidoPage>();
            builder.Services.AddTransient<DetalhesPedidoPage>();
            builder.Services.AddTransient<EditarPedidoPage>();
            builder.Services.AddTransient<FinalizarPedidoPage>();

            return builder.Build(); // ← SÓ UM BUILD
        }
    }
}