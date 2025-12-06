using EasyPedidos.ViewModels;
using Models;
using System.Windows.Input;

namespace EasyPedidos.Pages
{
    public partial class ListPedidoPage : ContentPage
    {
        public ICommand VisualizarPedidoFromPageCommand { get; }
        public ListPedidoPage(ListPedidoViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = viewModel;

            VisualizarPedidoFromPageCommand = new Command<PedidoModel>(async (pedido) =>
            {
                if (BindingContext is ListPedidoViewModel vm)
                {
                    await vm.VisualizarPedidoCommand.ExecuteAsync(pedido);
                }
            });
            // Monitorar mudanças no IsBusy
            if (viewModel != null)
            {
                viewModel.PropertyChanged += OnViewModelPropertyChanged;
            }
        }

        private void OnViewModelPropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(ListPedidoViewModel.IsBusy))
            {
                var viewModel = (ListPedidoViewModel)sender;
                
                // Forçar atualização do RefreshView quando IsBusy mudar para false
                if (!viewModel.IsBusy)
                {
                    // Pequeno delay para garantir que a UI atualize
                    Device.BeginInvokeOnMainThread(async () =>
                    {
                        await Task.Delay(100);
                        // O RefreshView deve detectar a mudança automaticamente
                        // Mas forçamos uma atualização se necessário
                        refreshView.IsRefreshing = false;
                    });
                }
            }
        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            
            // Limpar event handler
            if (BindingContext is ListPedidoViewModel viewModel)
            {
                viewModel.PropertyChanged -= OnViewModelPropertyChanged;
            }
        }
    }
}