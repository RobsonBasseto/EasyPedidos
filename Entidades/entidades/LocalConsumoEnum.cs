using System.ComponentModel;

namespace Entidades.entidades
{
    public enum LocalConsumoEnum
    {
        [Description("No Local")]
        NoLocal,
        [Description("Retirada")]
        Retirada,
        [Description("Entrega")]
        Entrega
    }
}
