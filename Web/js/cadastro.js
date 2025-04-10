document.querySelector(".form-container").addEventListener("submit", async function(event) {
    event.preventDefault(); // Impede o recarregamento da página
  
    const data = {
      nome: document.getElementById("nome").value,
      email: document.getElementById("email").value,
      telefone: document.getElementById("telefone").value,
      cpf_cnpj: document.getElementById("cpf_cnpj").value,
      cep: document.getElementById("cep").value,
      estado: document.getElementById("estado").value,
      cidade: document.getElementById("cidade").value,
      rua: document.getElementById("rua").value,
      numero: document.getElementById("numero").value,
      sem_numero: document.getElementById("sem_numero").checked
    };
  
    try {
      const response = await fetch("http://localhost:8000/api/imoveis/", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
      });
  
      if (response.ok) {
        alert("Cadastro realizado com sucesso!");
      } else {
        alert("Erro ao cadastrar. Verifique os campos.");
      }
    } catch (error) {
      console.error("Erro:", error);
      alert("Erro na comunicação com o servidor.");
    }
  });
