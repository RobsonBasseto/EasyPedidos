using EasyPedidos.ViewModels;

namespace EasyPedidos.Pages
{
    public partial class FinalizarPedidoPage : ContentPage
    {
        public FinalizarPedidoPage()
        {
            InitializeComponent();
            BindingContext = new FinalizarPedidoViewModel();
        }

        private void Entry_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
    }
}