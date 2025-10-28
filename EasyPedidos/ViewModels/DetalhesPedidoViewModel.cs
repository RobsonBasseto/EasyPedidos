using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using EasyPedidos.Pages;
using Entidades.entidades;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(PedidoSelecionado), "PedidoSelecionado")]
    public partial class DetalhesPedidoViewModel : BaseViewModel
    {
        public DetalhesPedidoViewModel()
        {
            Title = "Detalhes do Pedido";
        }

        [ObservableProperty]
        private Pedido pedidoSelecionado;

        [RelayCommand]
        private async Task Voltar()
        {
            await Shell.Current.GoToAsync("..");
        }
         
        [RelayCommand]
        private async Task EditarPedido()
        {
            if (pedidoSelecionado == null) return;

            var parameters = new Dictionary<string, object>
            {
                { "Pedido", pedidoSelecionado }
            };

            await Shell.Current.GoToAsync(nameof(EditarPedidoPage), parameters);
        }
    }
}