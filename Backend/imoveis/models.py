from django.db import models
from django.utils import timezone

TIPO_IMOVEL_CHOICES = [
    ('Casa', 'Casa'),
    ('Apartamento', 'Apartamento'),
    ('Kitnet', 'Kitnet'),
    ('Sala comercial', 'Sala comercial'),
]

STATUS_CHOICES = [
    ('Disponível', 'Disponível'),
    ('Alugado', 'Alugado'),
]

class Imovel(models.Model):
    tipo = models.CharField(max_length=20, choices=TIPO_IMOVEL_CHOICES)
    cep = models.CharField(max_length=9)
    estado = models.CharField(max_length=50)
    cidade = models.CharField(max_length=50)
    rua = models.CharField(max_length=100)
    numero = models.CharField(max_length=10, blank=True)
    sem_numero = models.BooleanField(default=False)

    quartos = models.IntegerField()
    banheiros = models.IntegerField()
    area = models.DecimalField(max_digits=6, decimal_places=2)
    aluguel = models.DecimalField(max_digits=10, decimal_places=2)

    ar_condicionado = models.BooleanField(default=False)
    garagem = models.BooleanField(default=False)
    piscina = models.BooleanField(default=False)
    mobiliado = models.BooleanField(default=False)
    permite_animais = models.BooleanField(default=False)
    mercado_proximo = models.BooleanField(default=False)
    onibus_proximo = models.BooleanField(default=False)
    internet = models.BooleanField(default=False)

    descricao = models.TextField()
    regras_adicionais = models.TextField(blank=True)

    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Disponível')
    data_cadastro = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.tipo} em {self.cidade} - {self.rua}, {self.numero or 'S/N'}"


