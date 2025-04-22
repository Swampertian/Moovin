from django.db import models
from django.contrib.auth.models import User
from immobile.models import Immobile

class Owner(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='owner_profile')
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    about_me = models.TextField()

    revenue_generated = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    rented_properties = models.PositiveIntegerField(default=0)
    rated_by_tenants = models.PositiveIntegerField(default=0)
    recommended_by_tenants = models.PositiveIntegerField(default=0)
    fast_responder = models.BooleanField(default=False)

    def __str__(self):
        return self.name

    @property
    def total_properties(self):
        return self.immobile_set.count()

    @property
    def active_properties(self):
        return self.immobile_set.filter(status='Available').count()

    @property
    def properties(self):
        return self.immobile_set.all().order_by('-created_at')
