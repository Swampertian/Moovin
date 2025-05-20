from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Rental
from notification.models import Notification

@receiver(post_save, sender=Rental)
def create_rental_notification(sender, instance, created, **kwargs):
    if created:
        # Notificar o proprietário do imóvel
        owner = instance.immobile.owner.user
        Notification.objects.create(
            user=owner,
            title="Imóvel Alugado com Sucesso",
            message=f"O inquilino {instance.tenant.name} alugou o imóvel {instance.immobile}.",
            type="RENTED_CONFIRMATION",
            related_object_id=instance.id,
            related_object_type="Rental"
        )

        # Notificar o inquilino
        tenant = instance.tenant.user
        Notification.objects.create(
            user=tenant,
            title="Aluguel Confirmado com Sucesso",
            message=f"Você alugou o imóvel {instance.immobile} com sucesso! Entre em contato com o proprietário para os próximos passos.",
            type="RENTED_CONFIRMATION",
            related_object_id=instance.id,
            related_object_type="Rental"
        )