using EasyPedidos.ViewModels;

namespace EasyPedidos.Pages
{
    public partial class PedidoPage : ContentPage
    {
        public PedidoPage()
        {
            InitializeComponent();
            BindingContext = new PedidoViewModel();
        }
    }
}