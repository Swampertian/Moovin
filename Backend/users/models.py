from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    name = models.CharField(max_length=200,null=False)
    email = models.EmailField(unique=True,null=False)
    
    user_type = models.CharField(max_length=15,
                                 choices=[('Inquilino','inquilino'),
                                          ('Proprietario','proprietario'),
                                          ('Admin','admin')],
                                 null=False)
    created = models.DateTimeField(auto_now_add=True)    

    USERNAME_FIELD ='email'
    REQUIRED_FIELDS=[]