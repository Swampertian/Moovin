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

// ETAPA 3 - Detalhes Finais
document.querySelector('.form-container[data-step="3"]')?.addEventListener('submit', async function(e) {
  e.preventDefault();
  
  const submitBtn = e.target.querySelector('button[type="submit"]');
  submitBtn.disabled = true;
  submitBtn.innerHTML = '<span class="loader"></span> Enviando...';

  try {
    // 1. Combinar todos os dados
    const formData = new FormData();
    
    // Dados do proprietário
    const ownerData = JSON.parse(localStorage.getItem('ownerData'));
    for (const [key, value] of Object.entries(ownerData)) {
      formData.append(key, value);
    }
    
    // Dados do imóvel
    const immobileData = JSON.parse(localStorage.getItem('immobileData'));
    for (const [key, value] of Object.entries(immobileData)) {
      formData.append(key, value);
    }
    
    // Dados da etapa 3
    formData.append('description', document.getElementById('descricao').value);
    formData.append('additional_rules', document.getElementById('regras').value);
    
    // Fotos
    const photosInput = document.getElementById('fotos');
    for (let i = 0; i < photosInput.files.length; i++) {
      formData.append('photos', photosInput.files[i]);
    }

    // 2. Enviar para a API
    const response = await fetch('http://localhost:8000/immobile_api/immobile/complete-registration/', {
      method: 'POST',
      body: formData,
      headers: {
        'X-CSRFToken': getCookie('csrftoken'),
      }
    });

    const result = await response.json();
    
    if (!response.ok) throw new Error(result.message || 'Erro no servidor');

    // 3. Feedback e redirecionamento
    Swal.fire({
      icon: 'success',
      title: 'Sucesso!',
      text: 'Imóvel cadastrado com ID: ' + result.id,
      confirmButtonText: 'OK'
    }).then(() => {
      localStorage.clear();
      window.location.href = '/dashboard/';
    });
    
  } catch (error) {
    Swal.fire({
      icon: 'error',
      title: 'Erro',
      text: error.message,
      confirmButtonText: 'Entendi'
    });
    submitBtn.disabled = false;
    submitBtn.textContent = 'Finalizar Cadastro';
  }
});