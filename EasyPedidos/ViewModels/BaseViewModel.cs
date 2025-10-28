using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Entidades.entidades;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace EasyPedidos.ViewModels
{
    public class BaseViewModel : ObservableObject
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        protected bool SetProperty<T>(ref T backingStore, T value, [CallerMemberName] string propertyName = "")
        {
            if (EqualityComparer<T>.Default.Equals(backingStore, value))
                return false;

            backingStore = value;
            OnPropertyChanged(propertyName);
            return true;
        }

        //[RelayCommand]
        //private async Task AtualizarStatus(Pedido pedido, StatusPedidoEnum novoStatus)
        //{
        //    if (pedido == null)
        //        return;

        //    pedido.Status = novoStatus;
        //   // await CarregarPedidos(); // Recarrega a lista para atualizar
        //}

        private bool _isBusy;
        public bool IsBusy
        {
            get => _isBusy;
            set => SetProperty(ref _isBusy, value);
        }

        private string _title = string.Empty;
        public string Title
        {
            get => _title;
            set => SetProperty(ref _title, value);
        }
    }
}

