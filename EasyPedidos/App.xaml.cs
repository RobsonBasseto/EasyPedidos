using EasyPedidos.Pages;

namespace EasyPedidos
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();
            Routing.RegisterRoute(nameof(DetalhesPedidoPage), typeof(DetalhesPedidoPage));
            Routing.RegisterRoute(nameof(EditarPedidoPage), typeof(EditarPedidoPage));
            Routing.RegisterRoute(nameof(PedidoPage), typeof(PedidoPage));
            Routing.RegisterRoute(nameof(ListPedidoPage), typeof(ListPedidoPage));
            Routing.RegisterRoute(nameof(FinalizarPedidoPage), typeof(FinalizarPedidoPage));

            MainPage = new AppShell();
        }
    }
}
