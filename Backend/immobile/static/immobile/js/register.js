// Certifique-se que o DOM está totalmente carregado
document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('.form-container[data-step="1"]');
  
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault(); // Impede o refresh
      
      // Coleta os dados (como você já tinha)
      const ownerData = {
        full_name: document.getElementById('nome').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('telefone').value,
        cpf_cnpj: document.getElementById('cpf_cnpj').value,
        postal_code: document.getElementById('cep').value,
        state: document.getElementById('estado').value,
        city: document.getElementById('cidade').value,
        street: document.getElementById('rua').value,
        number: document.getElementById('numero').value,
        no_number: document.getElementById('sem_numero').checked,
      };

      // Armazena no localStorage
      localStorage.setItem('ownerData', JSON.stringify(ownerData));
      
      // DEBUG: Verifique no console se os dados foram salvos
      console.log('Dados salvos:', ownerData);
      
      // Redireciona para a próxima página
      window.location.href = '/immobile_api/register/step2/';
    });
  } else {
    console.error('Formulário não encontrado! Verifique o seletor.');
  }
});

// ETAPA 2 - Dados do Imóvel
document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('.form-container[data-step="2"]');
  
  if (form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const noNumberChecked = document.getElementById('sem_numero_imovel').checked;

      const immobileData = {
        property_type: document.querySelector('input[name="tipo"]:checked')?.value,
        zip_code: document.getElementById('cep_imovel').value,
        state: document.getElementById('estado_imovel').value,
        city: document.getElementById('cidade_imovel').value,
        street: document.getElementById('rua_imovel').value,
        number: noNumberChecked ? '' : document.getElementById('numero_imovel').value,
        no_number: noNumberChecked,
        bedrooms: document.getElementById('quartos').value,
        bathrooms: document.getElementById('banheiros').value,
        area: document.getElementById('area').value,
        rent: document.getElementById('aluguel').value,
        air_conditioning: document.getElementById('ar_sim')?.checked || false,
        garage: document.getElementById('garagem_sim')?.checked || false,
        pool: document.getElementById('piscina_sim')?.checked || false,
        furnished: document.getElementById('mobilia_sim')?.checked || false,
        pet_friendly: document.getElementById('pet_sim')?.checked || false,
        nearby_market: document.getElementById('mercado_sim')?.checked || false,
        nearby_bus: document.getElementById('onibus_sim')?.checked || false,
        internet: document.getElementById('internet_sim')?.checked || false
      };

      localStorage.setItem('immobileData', JSON.stringify(immobileData));
      console.log('Dados do imóvel salvos:', immobileData);
      
      window.location.href = '/immobile_api/register/step3/';
    });
  }
});

// Função para pegar o token CSRF
function getCookie(name) {
  let cookieValue = null;
  if (document.cookie && document.cookie !== '') {
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i].trim();
      if (cookie.substring(0, name.length + 1) === (name + '=')) {
        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
        break;
      }
    }
  }
  return cookieValue;
}

// Verifica se o DOM está totalmente carregado
document.addEventListener('DOMContentLoaded', function() {
  // Seleciona o formulário da etapa 3
  const form = document.querySelector('form.form-container[data-step="3"]');
  
  if (!form) {
    console.error('Formulário não encontrado! Verifique:');
    console.log('- O elemento existe no DOM?');
    console.log('- O seletor está correto? (deve ser form.form-container[data-step="3"])');
    return;
  }

  form.addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalBtnText = submitBtn.innerHTML;
    
    try {
      // 1. Configura estado de carregamento
      submitBtn.disabled = true;
      submitBtn.innerHTML = `
        <span class="loader"></span> Enviando...
        <span class="loading-dots"></span>
      `;

      // 2. Validações básicas
      const descricao = document.getElementById('descricao').value;
      if (!descricao || descricao.length < 10) {
        throw new Error('A descrição deve ter pelo menos 10 caracteres');
      }

      const photosInput = document.getElementById('fotos');
      if (photosInput.files.length === 0) {
        throw new Error('Por favor, adicione pelo menos uma foto');
      }

      // 3. Combinar todos os dados
      const formData = new FormData();
      
      // Dados do proprietário
      const ownerData = JSON.parse(localStorage.getItem('ownerData') || {});
      for (const [key, value] of Object.entries(ownerData)) {
        if (value !== null && value !== undefined) {
          formData.append(`owner[${key}]`, value);
        }
      }
      
      // Dados do imóvel
      const immobileData = JSON.parse(localStorage.getItem('immobileData') || {});
      for (const [key, value] of Object.entries(immobileData)) {
        if (value !== null && value !== undefined) {
          formData.append(key, value);
        }
      }
      
      // Dados da etapa 3
      formData.append('description', descricao);
      formData.append('additional_rules', document.getElementById('regras').value);
      
      // Fotos
      for (let i = 0; i < photosInput.files.length; i++) {
        formData.append('photos', photosInput.files[i]);
      }

      // 4. Enviar para a API
      const response = await fetch('http://localhost:8000/immobile_api/immobile/complete-registration/', {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRFToken': getCookie('csrftoken'),
        }
      });

      // 5. Processar resposta
      if (!response.ok) {
        const errorResponse = await response.json().catch(() => ({}));
        throw new Error(
          errorResponse.message || 
          errorResponse.detail || 
          `Erro ${response.status}: ${response.statusText}`
        );
      }

      const result = await response.json();

      // 6. Feedback de sucesso
      if (typeof Swal !== 'undefined') {
        await Swal.fire({
          icon: 'success',
          title: 'Sucesso!',
          text: `Imóvel cadastrado com ID: ${result.id || 'N/A'}`,
          confirmButtonText: 'OK'
        });
      } else {
        alert(`Sucesso! Imóvel cadastrado com ID: ${result.id || 'N/A'}`);
      }

      // 7. Limpar e redirecionar
      localStorage.clear();
      window.location.href = '/dashboard/';

    } catch (error) {
      console.error('Erro no envio:', error);
      
      // Feedback de erro
      if (typeof Swal !== 'undefined') {
        await Swal.fire({
          icon: 'error',
          title: 'Erro',
          text: error.message,
          confirmButtonText: 'Entendi'
        });
      } else {
        alert('Erro: ' + error.message);
      }

      // Restaurar botão
      submitBtn.disabled = false;
      submitBtn.innerHTML = originalBtnText;
    }
  });
});