const API_BASE_URL = 'http://localhost:3000/api';
const LANCHES_API_URL = `${API_BASE_URL}/lanches`;
const INGREDIENTES_API_URL = `${API_BASE_URL}/ingredientes`;

let state = {
    lanches: [],
    ingredientes: [],
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
const ingredientesDisponiveisList = document.getElementById('ingredientesDisponiveisList');

// Initialize
document.addEventListener('DOMContentLoaded', async () => {
    await Promise.all([fetchIngredientes(), fetchLanches()]);

    btnNovoLanche.addEventListener('click', openAddModal);
    btnCancelar.addEventListener('click', closeModal);
    lancheForm.addEventListener('submit', handleFormSubmit);
});

// Functions
async function fetchLanches() {
    try {
        const response = await fetch(LANCHES_API_URL);
        state.lanches = await response.json();
        renderTable();
    } catch (error) {
        console.error('Erro ao buscar lanches:', error);
        alert('Erro ao conectar com a API. Verifique se o servidor está rodando.');
    }
}

async function fetchIngredientes() {
    try {
        const response = await fetch(INGREDIENTES_API_URL);
        state.ingredientes = await response.json();
        renderIngredientesCheckboxes();
    } catch (error) {
        console.error('Erro ao buscar ingredientes:', error);
        alert('Erro ao buscar ingredientes da API.');
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
                    ${(lanche.ingredientes || []).map(ing => `<span class="bg-orange-100 text-orange-700 px-2 py-1 rounded-full text-xs">${ing}</span>`).join('')}
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
    ingredientesDisponiveisList.innerHTML = '';

    state.ingredientes.forEach(ing => {
        const idSafe = ing.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/\s+/g, '-').toLowerCase();

        const divIngrediente = document.createElement('div');
        divIngrediente.className = 'flex items-center mb-1';
        divIngrediente.innerHTML = `
            <input type="checkbox" name="ingredientes" value="${ing}" id="ing-${idSafe}" class="form-checkbox h-4 w-4 text-orange-500 rounded">
            <label for="ing-${idSafe}" class="ml-2 text-sm text-gray-700">${ing}</label>
        `;

        const divIngredienteDisponivel = document.createElement('div');
        divIngredienteDisponivel.className = 'flex items-center mb-1';
        divIngredienteDisponivel.innerHTML = `
            <input type="checkbox" name="ingredientesDisponiveis" value="${ing}" id="ing-disp-${idSafe}" class="form-checkbox h-4 w-4 text-orange-500 rounded">
            <label for="ing-disp-${idSafe}" class="ml-2 text-sm text-gray-700">${ing}</label>
        `;

        ingredientesList.appendChild(divIngrediente);
        ingredientesDisponiveisList.appendChild(divIngredienteDisponivel);
    });
}

function openAddModal() {
    state.isEditing = false;
    modalTitle.innerText = 'Novo Lanche';
    lancheForm.reset();
    document.getElementById('lancheId').value = '';

    document.querySelectorAll('input[name="ingredientesDisponiveis"]').forEach(cb => {
        cb.checked = true;
    });

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

    const selectedIngredientesDisponiveis = Array.from(document.querySelectorAll('input[name="ingredientesDisponiveis"]:checked'))
        .map(cb => cb.value);

    if (selectedIngredientes.length === 0) {
        alert('Selecione pelo menos um ingrediente do lanche.');
        return;
    }

    if (selectedIngredientesDisponiveis.length === 0) {
        alert('Selecione pelo menos um ingrediente disponível.');
        return;
    }

    const lancheData = {
        nome,
        preco: parseFloat(preco),
        ingredientes: selectedIngredientes,
        ingredientesDisponiveis: selectedIngredientesDisponiveis,
        disponivel
    };

    try {
        let response;
        if (state.isEditing) {
            response = await fetch(`${LANCHES_API_URL}/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(lancheData)
            });
        } else {
            response = await fetch(LANCHES_API_URL, {
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

    document.querySelectorAll('input[name="ingredientes"]').forEach(cb => {
        cb.checked = (lanche.ingredientes || []).includes(cb.value);
    });

    document.querySelectorAll('input[name="ingredientesDisponiveis"]').forEach(cb => {
        cb.checked = (lanche.ingredientesDisponiveis || []).includes(cb.value);
    });

    modalLanche.classList.remove('hidden');
}

async function deleteLanche(id) {
    if (!confirm('Tem certeza que deseja excluir este lanche?')) return;

    try {
        const response = await fetch(`${LANCHES_API_URL}/${id}`, {
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
