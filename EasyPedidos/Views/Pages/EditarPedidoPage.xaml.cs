using EasyPedidos.ViewModels;

namespace EasyPedidos.Pages
{
    public partial class EditarPedidoPage : ContentPage
    {
        public EditarPedidoPage(EditarPedidoViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = viewModel;
        }
    }
}