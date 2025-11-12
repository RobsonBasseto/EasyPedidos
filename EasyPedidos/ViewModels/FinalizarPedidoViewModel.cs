using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using EasyPedidos.Helpers;
using Entidades.entidades;
using Models;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(Pedido), "Pedido")]
    public partial class FinalizarPedidoViewModel : BaseViewModel
    {
        public FinalizarPedidoViewModel()
        {
            Title = "Finalizar Pedido";
            CarregarFormasPagamento();
        }

        [ObservableProperty]
        private PedidoModel _pedido;

        [ObservableProperty]
        private FormaPagamentoEnum _formaPagamentoSelecionada;

        [ObservableProperty]
        private string _valorRecebidoString;

        public decimal ValorRecebido => decimal.TryParse(ValorRecebidoString, out var v) ? v : 0;

        [ObservableProperty]
        private decimal _troco;

        [ObservableProperty]
        private bool _temTroco;

        [ObservableProperty]
        private bool _mostrarCampoDinheiro = true;

        public ObservableCollection<FormaPagamentoEnum> FormasPagamento { get; } = new();

        private void CarregarFormasPagamento()
        {
            FormasPagamento.Add(FormaPagamentoEnum.Dinheiro);
            FormasPagamento.Add(FormaPagamentoEnum.CartaoCredito);
            FormasPagamento.Add(FormaPagamentoEnum.CartaoDebito);
            FormasPagamento.Add(FormaPagamentoEnum.Pix);
        }

        partial void OnFormaPagamentoSelecionadaChanged(FormaPagamentoEnum value)
        {
            MostrarCampoDinheiro = value == FormaPagamentoEnum.Dinheiro;
            ValorRecebidoString = string.Empty;
            Troco = 0;
            TemTroco = false;
        }

        partial void OnValorRecebidoStringChanged(string value) => CalcularTroco();

        private void CalcularTroco()
        {
            if (Pedido == null) return;

            if (ValorRecebido > 0)
            {
                Troco = ValorRecebido - Pedido.Total;
                TemTroco = Troco > 0;
            }
            else
            {
                Troco = 0;
                TemTroco = false;
            }
        }

        [RelayCommand]
        private async Task Finalizar()
        {
            if (Pedido == null) return;

            if (FormaPagamentoSelecionada == FormaPagamentoEnum.Dinheiro)
            {
                if (ValorRecebido <= 0)
                {
                    await Shell.Current.DisplayAlert("Erro", "Digite o valor recebido.", "OK");
                    return;
                }
                if (ValorRecebido < Pedido.Total)
                {
                    await Shell.Current.DisplayAlert("Erro", "Valor insuficiente.", "OK");
                    return;
                }
            }

            var msg = $"Finalizar pedido da {Pedido.Identificador}?\n" +
                      $"Total: R$ {Pedido.Total:F2}\n" +
                      $"Pagamento: {FormaPagamentoSelecionada.GetDescription()}";

            if (FormaPagamentoSelecionada == FormaPagamentoEnum.Dinheiro && TemTroco)
                msg += $"\nTroco: R$ {Troco:F2}";

            bool confirmar = await Shell.Current.DisplayAlert("Confirmar", msg, "Sim", "Cancelar");
            if (confirmar)
            {
                Pedido.Status = StatusPedidoEnum.Faturado;
                Pedido.FormaPagamento = FormaPagamentoSelecionada;
                Pedido.DataFaturamento = DateTime.Now;

                PedidoViewModel.AtualizarPedido(Pedido);
                MessagingCenter.Send(this, "PedidoAtualizado", Pedido);

                await Shell.Current.DisplayAlert("Sucesso", "Pedido faturado!", "OK");
                await Shell.Current.GoToAsync("..");
            }
        }

        [RelayCommand]
        private async Task Cancelar() => await Shell.Current.GoToAsync("..");
    }
}