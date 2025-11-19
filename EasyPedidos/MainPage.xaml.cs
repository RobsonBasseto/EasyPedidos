using EasyPedidos.Pages;
using EasyPedidos.ViewModels;

namespace EasyPedidos
{
    public partial class MainPage : ContentPage
    {
        int count = 0;

        public MainPage()
        {
            InitializeComponent();
        }

        private async void OnNovoPedidoClicked(object sender, EventArgs e)
        {
            // Navega para a tela de novo pedido
            await Navigation.PushAsync(new PedidoPage());
        }

        private async void OnListarPedidosClicked(object sender, EventArgs e)
        {
            // Navega para a tela de listar pedidos
            await Navigation.PushAsync(new ListPedidoPage(new ListPedidoViewModel()));
        }

    }

}
