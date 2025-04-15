from django.db import models
from django.utils import timezone

PROPERTY_TYPE_CHOICES = [
    ('House', 'House'),
    ('Apartment', 'Apartment'),
    # Adicione outros conforme necessário
]

STATUS_CHOICES = [
    ('Available', 'Available'),
    ('Rented', 'Rented'),
    ('Unavailable', 'Unavailable'),
]

class Owner(models.Model):
    full_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone = models.CharField(max_length=20)
    cpf_cnpj = models.CharField(max_length=20, unique=True)
    postal_code = models.CharField(max_length=10)
    state = models.CharField(max_length=2)
    city = models.CharField(max_length=50)
    street = models.CharField(max_length=100)
    number = models.CharField(max_length=10, blank=True, null=True)
    no_number = models.BooleanField(default=False)
    
    def __str__(self):
        return self.full_name
    
class Immobile(models.Model):
    id_immobile = models.IntegerField(primary_key=True)
    property_type = models.CharField(max_length=20, choices=PROPERTY_TYPE_CHOICES,default='House')
    zip_code = models.CharField(max_length=9)
    state = models.CharField(max_length=50)
    city = models.CharField(max_length=50)
    street = models.CharField(max_length=100)
    number = models.CharField(max_length=10, blank=True)
    no_number = models.BooleanField(default=False)

    bedrooms = models.IntegerField()
    bathrooms = models.IntegerField()
    area = models.DecimalField(max_digits=6, decimal_places=2)
    rent = models.DecimalField(max_digits=10, decimal_places=2)

    air_conditioning = models.BooleanField(default=False)
    garage = models.BooleanField(default=False)
    pool = models.BooleanField(default=False)
    furnished = models.BooleanField(default=False)
    pet_friendly = models.BooleanField(default=False)
    nearby_market = models.BooleanField(default=False)
    nearby_bus = models.BooleanField(default=False)
    internet = models.BooleanField(default=False)

    description = models.TextField()
    additional_rules = models.TextField(blank=True)

    status = models.CharField(max_length=15, choices=STATUS_CHOICES, default='Available')
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.property_type} in {self.city} - {self.street}, {self.number or 'No number'}"

class Photo(models.Model):
    immobile = models.ForeignKey(Immobile, on_delete=models.CASCADE, related_name='photos')
    image = models.ImageField(upload_to='properties/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Foto {self.id} - {self.immobile}"
