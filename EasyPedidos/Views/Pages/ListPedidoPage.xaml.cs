using EasyPedidos.ViewModels;

namespace EasyPedidos.Pages
{
    public partial class ListPedidoPage : ContentPage
    {
        public ListPedidoPage()
        {
            InitializeComponent();
            BindingContext = new ListPedidoViewModel();

        }
    }

}
