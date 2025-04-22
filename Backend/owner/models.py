from django.db import models
from django.contrib.auth.models import User

class Owner(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)


    # Dados básicos
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=20, blank=True)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    about_me = models.TextField(blank=True)

    # Estatísticas da plataform
    rented_properties = models.PositiveIntegerField(default=0)
    revenue_generated = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    rated_by_tenants = models.PositiveIntegerField(default=0)
    recommended_by_tenants = models.PositiveIntegerField(default=0)
    fast_responder = models.BooleanField(default=False)
    member_since = models.DateField(auto_now_add=True)

    def __str__(self):
        return self.name

    @property
    def total_properties(self):
        return self.user.imoveis.count()


