const API_URL = 'http://localhost:3000/api/lanches';

const INGREDIENTES_PADRAO = [
    "Pão", "Hambúrguer", "Queijo", "Alface", "Tomate", "Cebola", "Bacon", "Ovo", "Molho especial"
];

let state = {
    lanches: [],
    isEditing: false
};

// DOM Elements
const lanchesTableBody = document.getElementById('lanchesTableBody');
const btnNovoLanche = document.getElementById('btnNovoLanche');
const modalLanche = document.getElementById('modalLanche');
const lancheForm = document.getElementById('lancheForm');
const modalTitle = document.getElementById('modalTitle');
const btnCancelar = document.getElementById('btnCancelar');
const ingredientesList = document.getElementById('ingredientesList');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    fetchLanches();
    renderIngredientesCheckboxes();

    btnNovoLanche.addEventListener('click', openAddModal);
    btnCancelar.addEventListener('click', closeModal);
    lancheForm.addEventListener('submit', handleFormSubmit);
});

// Functions
async function fetchLanches() {
    try {
        const response = await fetch(API_URL);
        state.lanches = await response.json();
        renderTable();
    } catch (error) {
        console.error('Erro ao buscar lanches:', error);
        alert('Erro ao conectar com a API. Verifique se o servidor está rodando.');
    }
}

function renderTable() {
    lanchesTableBody.innerHTML = '';

    state.lanches.forEach(lanche => {
        const tr = document.createElement('tr');
        tr.className = 'hover:bg-gray-50 transition duration-150';

        tr.innerHTML = `
            <td class="px-5 py-5 border-b border-gray-200 text-sm">
                <p class="text-gray-900 font-bold">${lanche.nome}</p>
            </td>
            <td class="px-5 py-5 border-b border-gray-200 text-sm">
                <p class="text-gray-900">R$ ${lanche.preco.toFixed(2)}</p>
            </td>
            <td class="px-5 py-5 border-b border-gray-200 text-sm">
                <div class="flex flex-wrap gap-1">
                    ${lanche.ingredientes.map(ing => `<span class="bg-orange-100 text-orange-700 px-2 py-1 rounded-full text-xs">${ing}</span>`).join('')}
                </div>
            </td>
            <td class="px-5 py-5 border-b border-gray-200 text-sm">
                <span class="relative inline-block px-3 py-1 font-semibold ${lanche.disponivel ? 'text-green-900' : 'text-red-900'} leading-tight">
                    <span aria-hidden class="absolute inset-0 ${lanche.disponivel ? 'bg-green-200' : 'bg-red-200'} opacity-50 rounded-full"></span>
                    <span class="relative">${lanche.disponivel ? 'Disponível' : 'Indisponível'}</span>
                </span>
            </td>
            <td class="px-5 py-5 border-b border-gray-200 text-sm text-right flex gap-2">
                <button onclick="editLanche('${lanche.id}')" class="text-indigo-600 hover:text-indigo-900 font-bold">Editar</button>
                <button onclick="deleteLanche('${lanche.id}')" class="text-red-600 hover:text-red-900 font-bold">Excluir</button>
            </td>
        `;
        lanchesTableBody.appendChild(tr);
    });
}

function renderIngredientesCheckboxes() {
    ingredientesList.innerHTML = '';
    INGREDIENTES_PADRAO.forEach(ing => {
        const div = document.createElement('div');
        div.className = 'flex items-center mb-1';
        div.innerHTML = `
            <input type="checkbox" name="ingredientes" value="${ing}" id="ing-${ing}" class="form-checkbox h-4 w-4 text-orange-500 rounded">
            <label for="ing-${ing}" class="ml-2 text-sm text-gray-700">${ing}</label>
        `;
        ingredientesList.appendChild(div);
    });
}

function openAddModal() {
    state.isEditing = false;
    modalTitle.innerText = 'Novo Lanche';
    lancheForm.reset();
    document.getElementById('lancheId').value = '';
    modalLanche.classList.remove('hidden');
}

function closeModal() {
    modalLanche.classList.add('hidden');
}

async function handleFormSubmit(e) {
    e.preventDefault();

    const id = document.getElementById('lancheId').value;
    const nome = document.getElementById('nome').value;
    const preco = document.getElementById('preco').value;
    const disponivel = document.getElementById('disponivel').checked;

    const selectedIngredientes = Array.from(document.querySelectorAll('input[name="ingredientes"]:checked'))
        .map(cb => cb.value);

    if (selectedIngredientes.length === 0) {
        alert('Selecione pelo menos um ingrediente.');
        return;
    }

    const lancheData = {
        nome,
        preco: parseFloat(preco),
        ingredientes: selectedIngredientes,
        disponivel
    };

    try {
        let response;
        if (state.isEditing) {
            response = await fetch(`${API_URL}/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(lancheData)
            });
        } else {
            response = await fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(lancheData)
            });
        }

        if (response.ok) {
            closeModal();
            fetchLanches();
        } else {
            const error = await response.json();
            alert('Erro ao salvar: ' + error.error);
        }
    } catch (error) {
        console.error('Erro na requisição:', error);
    }
}

async function editLanche(id) {
    state.isEditing = true;
    modalTitle.innerText = 'Editar Lanche';

    const lanche = state.lanches.find(l => l.id === id);
    if (!lanche) return;

    document.getElementById('lancheId').value = lanche.id;
    document.getElementById('nome').value = lanche.nome;
    document.getElementById('preco').value = lanche.preco;
    document.getElementById('disponivel').checked = lanche.disponivel;

    // Set checkboxes
    const checkboxes = document.querySelectorAll('input[name="ingredientes"]');
    checkboxes.forEach(cb => {
        cb.checked = lanche.ingredientes.includes(cb.value);
    });

    modalLanche.classList.remove('hidden');
}

async function deleteLanche(id) {
    if (!confirm('Tem certeza que deseja excluir este lanche?')) return;

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        if (response.ok) {
            fetchLanches();
        } else {
            alert('Erro ao excluir lanche.');
        }
    } catch (error) {
        console.error('Erro ao excluir:', error);
    }
}
