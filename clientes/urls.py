# clientes/urls.py
"""URLs de la app clientes — W02 (inicio) + W07 (Lista + Detalle)."""
from django.urls import path
from . import views

app_name = 'clientes'

urlpatterns = [
    # Inicio (W02)
    path('inicio/', views.index, name='inicio'),

    # Lectura (W07)
    path('',
         views.ClienteListView.as_view(),
         name='lista'),
    path('<int:cliente_id>/',
         views.ClienteDetailView.as_view(),
         name='detalle'),
]