from django.db import models
from django.utils import timezone
from .consts import *
from tenant.models import Tenant


class Immobile(models.Model):
    owner = models.ForeignKey('owner.Owner', related_name='properties', on_delete=models.CASCADE, null=True,blank=True)

    id_immobile = models.AutoField(primary_key=True)
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

class ImmobilePhoto(models.Model):
    immobile = models.ForeignKey(Immobile, related_name='photos_blob', on_delete=models.CASCADE)
    image_blob = models.BinaryField(default=bytes)
    content_type = models.CharField(max_length=50, default='')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Photo (BLOB) for {self.immobile}"

class Payment(models.Model):
    immobile = models.ForeignKey(Immobile, related_name='payments', on_delete=models.CASCADE)
    amount_received = models.DecimalField(max_digits=10, decimal_places=2)
    date_received = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Payment of {self.amount_received} for {self.immobile} on {self.date_received}"

class Rental(models.Model):
    tenant = models.ForeignKey(Tenant,on_delete=models.CASCADE, blank=False,null=False)
    immobile = models.ForeignKey(Immobile,on_delete=models.CASCADE, blank=False,null=False)
    start_data = models.DateField(blank=False,null=False)
    end_data = models.DateField(blank=False,null=False)
    status =  models.CharField(max_length=15, choices=RENT_STATUS_CHOICES)
    value = models.DecimalField(max_digits=10, decimal_places=2)