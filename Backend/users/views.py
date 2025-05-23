from django.shortcuts import render, redirect
from django.contrib.auth import authenticate,login,logout
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser
from .models import *
from .serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from rest_framework.views import APIView
from django.core.mail import send_mail
from django.conf import settings
import random
import string
from .models import EmailVerificationCode
class UserRegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
# View para testar o uso do JWT,
# deverá ser excluída juntamente com sua respectiva rota 
class ProtectedView(APIView): 
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({'message': f'Olá {request.user.username}, você está autenticado com JWT!'})

def UserLogout(request):

    logout(request)
    return redirect('get-token')

class UserUpdateView(generics.UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]

class UserRetriverView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]
    def get_object(self):
        """
        Sobrescreve o método get_object para buscar o usuário através do
        JWT (request.user), que já contém o pk do usuário autenticado.
        """
        user = self.request.user  # O user é populado automaticamente com o JWT

        if not user:
            raise NotFound("Usuário não encontrado.")

        return user
    

class UserDeleteView(generics.DestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]

class RequestEmailVerification(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')
        if not email:
            return Response({'error': 'O e-mail é obrigatório.'}, status=status.HTTP_400_BAD_REQUEST)

        # Gerar um código de verificação aleatório
        verification_code = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(6))

        try:
            # Salvar o código de verificação (com um tempo de expiração)
            EmailVerificationCode.objects.update_or_create(
                email=email,
                defaults={'code': verification_code}
            )

            # Enviar o e-mail
            subject = 'Verifique seu e-mail'
            message = f'Seu código de verificação é: {verification_code}'
            from_email = settings.DEFAULT_FROM_EMAIL
            recipient_list = [email]
            send_mail(subject, message, from_email, recipient_list)

            return Response({'status': 'success', 'message': 'Código de verificação enviado para o seu e-mail.'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'status': 'error', 'message': f'Erro ao enviar o e-mail: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VerifyEmailCode(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')
        code = request.data.get('code')

        if not email or not code:
            return Response({'error': 'Email e código são obrigatórios.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            verification_entry = EmailVerificationCode.objects.get(email=email, code=code)
            now = timezone.now()
            expiration_time = verification_entry.created_at + datetime.timedelta(minutes=15)

            print(f"Agora bim: {now}")
            print(f"Criado em: {verification_entry.created_at}")
            print(f"Expira em: {expiration_time}")

            if not verification_entry.is_expired():
                verification_entry.delete()
                return Response({'status': 'success', 'message': 'Email verificado com sucesso.'}, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Código de verificação expirou.'}, status=status.HTTP_400_BAD_REQUEST)
        except EmailVerificationCode.DoesNotExist:
            return Response({'error': 'Código de verificação inválido.'}, status=status.HTTP_400_BAD_REQUEST)