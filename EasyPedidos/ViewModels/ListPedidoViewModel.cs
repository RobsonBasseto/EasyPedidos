using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using CommunityToolkit.Mvvm.Messaging;
using EasyPedidos.Helpers;
using EasyPedidos.Pages;
using Entidades.entidades;
using Models;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    public partial class ListPedidoViewModel : BaseViewModel
    {
        public ListPedidoViewModel()
        {
            Title = "Pedidos";
            FiltroSelecionado = StatusPedidoEnum.EmPreparo;

            // Carregar pedidos inicialmente
            Task.Run(() => CarregarPedidosSilencioso());

            WeakReferenceMessenger.Default.Register<PedidoAtualizadoMessage>(this, (r, m) =>
            {
                // Atualizar silenciosamente quando receber mensagem
                Task.Run(() => CarregarPedidosSilencioso());
            });
        }

        [ObservableProperty]
        private ObservableCollection<PedidoModel> _pedidos = new();

        [ObservableProperty]
        private ObservableCollection<PedidoModel> _todosPedidos = new();

        [ObservableProperty]
        private StatusPedidoEnum _filtroSelecionado;

        public List<StatusPedidoEnum> Filtros { get; } = new()
        {
            StatusPedidoEnum.Todos,
            StatusPedidoEnum.EmPreparo,
            StatusPedidoEnum.Pronto,
            StatusPedidoEnum.Faturado
        };

        partial void OnFiltroSelecionadoChanged(StatusPedidoEnum value) => AplicarFiltro();

        // Método para carregamento silencioso (sem afetar IsBusy)
        private async Task CarregarPedidosSilencioso()
        {
            try
            {
                var pedidos = PedidoViewModel.ObterPedidos();

                // Atualizar na thread UI
                await MainThread.InvokeOnMainThreadAsync(() =>
                {
                    TodosPedidos.Clear();
                    foreach (var p in pedidos) TodosPedidos.Add(p);
                    AplicarFiltro();
                });
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Erro ao carregar pedidos: {ex.Message}");
            }
        }

        [RelayCommand]
        private async Task CarregarPedidos()
        {
            try
            {
                IsBusy = true;
                // Pequeno delay para mostrar o feedback visual
                await Task.Delay(1000);

                var pedidos = PedidoViewModel.ObterPedidos();

                TodosPedidos.Clear();
                foreach (var p in pedidos) TodosPedidos.Add(p);
                AplicarFiltro();
                IsBusy = false;
            }
            catch (Exception ex)
            {
                await Shell.Current.DisplayAlert("Erro", "Não foi possível carregar os pedidos.", "OK");
                System.Diagnostics.Debug.WriteLine($"Erro: {ex.Message}");
            }
            finally
            {
            }
        }

        private void AplicarFiltro()
        {
            try
            {
                var filtrados = FiltroSelecionado switch
                {
                    StatusPedidoEnum.EmPreparo => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.EmPreparo),
                    StatusPedidoEnum.Pronto => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.Pronto),
                    StatusPedidoEnum.Faturado => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.Faturado),
                    StatusPedidoEnum.Todos => TodosPedidos,
                    _ => TodosPedidos
                };

                Pedidos = new ObservableCollection<PedidoModel>(filtrados.OrderByDescending(p => p.DataHora));
                Title = $"Pedidos - {FiltroSelecionado.GetDescription()}";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Erro ao aplicar filtro: {ex.Message}");
            }
        }

        [RelayCommand]
        private async Task VisualizarPedido(PedidoModel pedido)
        {
            if (pedido == null) return;

            if (IsBusy) return;

            try
            {
                await Shell.Current.GoToAsync(nameof(DetalhesPedidoPage), true, new Dictionary<string, object>
                {
                    { "Pedido", pedido }
                });
            }
            catch (Exception ex)
            {
                await Shell.Current.DisplayAlert("Erro", "Não foi possível abrir os detalhes do pedido.", "OK");
                System.Diagnostics.Debug.WriteLine($"Erro ao abrir detalhes: {ex.Message}");
            }
        }

        [RelayCommand]
        private async Task FinalizarPedido(PedidoModel pedido)
        {
            if (pedido?.Status != StatusPedidoEnum.Pronto)
            {
                await Shell.Current.DisplayAlert("Bloqueado", "Apenas pedidos PRONTOS podem ser finalizados.", "OK");
                return;
            }

            try
            {
                await Shell.Current.GoToAsync(nameof(FinalizarPedidoPage), true, new Dictionary<string, object>
                {
                    { "Pedido", pedido }
                });
            }
            catch (Exception ex)
            {
                await Shell.Current.DisplayAlert("Erro", "Não foi possível finalizar o pedido.", "OK");
            }
        }

        [RelayCommand]
        private async Task AtualizarLista()
        {
            await CarregarPedidos();
        }

        [RelayCommand]
        private void CarregarMais()
        {
            // Por enquanto, apenas recarrega a lista
            // Futuramente pode implementar paginação
            Task.Run(() => CarregarPedidosSilencioso());
        }
    }
}