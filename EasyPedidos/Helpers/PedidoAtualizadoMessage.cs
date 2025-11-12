using CommunityToolkit.Mvvm.Messaging.Messages;
using Models;

namespace EasyPedidos.Helpers
{
    public class PedidoAtualizadoMessage : ValueChangedMessage<PedidoModel>
    {
        public PedidoAtualizadoMessage(PedidoModel pedido) : base(pedido) { }
    }
}