// ViewModels/MainViewModel.cs
using CommunityToolkit.Mvvm.Input;
using EasyPedidos.Pages;

namespace EasyPedidos.ViewModels
{
    public partial class MainViewModel : BaseViewModel
    {
        public MainViewModel()
        {
            Title = "Easy Pedidos";
        }

        [RelayCommand]
        private async Task NavigateToNovoPedido()
        {
            await Shell.Current.GoToAsync(nameof(PedidoPage));
        }

        [RelayCommand]
        private async Task NavigateToListarPedidos()
        {
            await Shell.Current.GoToAsync(nameof(ListPedidoPage));
        }
    }
}