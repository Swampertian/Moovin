from django.db import models
from django.contrib.auth.models import User

class Tenant(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='tenant_profile')
    name = models.CharField(max_length=100)
    age = models.PositiveIntegerField()
    job = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    about_me = models.TextField()
    
    # Rental preferences
    prefers_studio = models.BooleanField(default=False)
    prefers_apartment = models.BooleanField(default=False)
    prefers_shared_rent = models.BooleanField(default=False)
    accepts_pets = models.BooleanField(default=False)

    # User rating
    user_rating = models.FloatField(default=0.0)

    # Platform history
    properties_rented = models.PositiveIntegerField(default=0)
    rated_by_landlords = models.PositiveIntegerField(default=0)
    recommended_by_landlords = models.PositiveIntegerField(default=0)
    favorited_properties = models.PositiveIntegerField(default=0)
    fast_responder = models.BooleanField(default=False)
    member_since = models.DateField(auto_now_add=True)

    def __str__(self):
        return self.name

