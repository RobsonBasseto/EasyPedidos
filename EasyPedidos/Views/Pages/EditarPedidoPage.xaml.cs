using EasyPedidos.ViewModels;
using Models;

namespace EasyPedidos.Pages
{
    public partial class EditarPedidoPage : ContentPage
    {
        private readonly EditarPedidoViewModel _viewModel;
        private bool _salvou = false; // ← Flag para saber se salvou

        public EditarPedidoPage(EditarPedidoViewModel viewModel)
        {
            InitializeComponent();
            _viewModel = viewModel;
            BindingContext = viewModel;
        }

        // CHAMADO QUANDO O USUÁRIO SAI DA TELA
        protected override void OnDisappearing()
        {
            base.OnDisappearing();

            // SE NÃO SALVOU → RESTAURA O ORIGINAL
            if (!_salvou && _viewModel.PedidoOld != null && _viewModel.Pedido != null)
            {
                RestaurarPedidoOriginal();
            }
        }

        // CHAMADO PELO VIEWMODEL QUANDO SALVAR
        public void MarcarComoSalvo()
        {
            _salvou = true;
        }

        private void RestaurarPedidoOriginal()
        {
            var original = _viewModel.PedidoOld;

            // RESTAURA PROPRIEDADES
            _viewModel.Pedido.Identificador = original.Identificador;
            _viewModel.Pedido.IsMesa = original.IsMesa;
            _viewModel.Pedido.LocalConsumo = original.LocalConsumo;
            _viewModel.Pedido.Total = original.Total;

            // RESTAURA ITENS
            _viewModel.Pedido.Itens.Clear();
            foreach (var item in original.Itens)
            {
                _viewModel.Pedido.Itens.Add(new ItemPedidoModel
                {
                    Id = item.Id,
                    Nome = item.Nome,
                    Preco = item.Preco,
                    Quantidade = item.Quantidade,
                    Observacao = item.Observacao
                });
            }
        }
    }
}