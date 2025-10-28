using EasyPedidos.ViewModels;

namespace EasyPedidos.Pages
{
    public partial class DetalhesPedidoPage : ContentPage
    {
        public DetalhesPedidoPage(DetalhesPedidoViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = viewModel;
        }
    }
}