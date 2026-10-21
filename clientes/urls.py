# clientes/urls.py
"""URLs de la app clientes — W07 (Lista + Detalle)."""
from django.urls import path
from . import views

app_name = 'clientes'

urlpatterns = [
    path('inicio/',
         views.ClienteListView.as_view(),
         name='inicio'),
    path('',
         views.ClienteListView.as_view(),
         name='lista'),
    path('<int:cliente_id>/',
         views.ClienteDetailView.as_view(),
         name='detalle'),
]