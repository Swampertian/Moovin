from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Review
from notification.models import Notification
from django.contrib.contenttypes.models import ContentType
from immobile.models import Immobile 
from users.models import User
from tenant.models import Tenant
from owner.models import Owner

@receiver(post_save, sender=Review)
def create_review_notification(sender, instance, created, **kwargs):
    if created:
        review_type = instance.type
        target_id = instance.object_id
        content_type = instance.content_type

        # Determinar o destinatário e a mensagem com base no tipo de avaliação
        if review_type == 'PROPERTY':
            # Buscar o imóvel e seu proprietário
            try:
                immobile = Immobile.objects.get(id_immobile=target_id)
                recipient = immobile.owner.user  # Proprietário do imóvel
                message = f"Seu imóvel '{immobile}' recebeu uma nova avaliação com nota {instance.rating}."
            except Immobile.DoesNotExist:
                return  # Não criar notificação se o imóvel não for encontrado
        elif review_type == 'TENANT':
            # Buscar o inquilino
            try:
                tenant = Tenant.objects.get(id=target_id)
                recipient = tenant.user
                message = f"Você recebeu uma nova avaliação como inquilino com nota {instance.rating}."
            except Tenant.DoesNotExist:
                return  # Não criar notificação se o inquilino não for encontrado
        elif review_type == 'OWNER':
            # Buscar o proprietário
            try:
                owner = Owner.objects.get(id=target_id)
                recipient = owner.user
                message = f"Você recebeu uma nova avaliação como proprietário com nota {instance.rating}."
            except Owner.DoesNotExist:
                return  # Não criar notificação se o proprietário não for encontrado
        else:
            return  # Não criar notificação para tipos inválidos

        # Criar a notificação
        Notification.objects.create(
            user=recipient,
            title="Avaliação Recebida",
            message=message,
            type="REVIEW_RECEIVED",
            related_object_id=instance.id,
            related_object_type="Review"
        )