# productos/urls.py
"""URLs de la app productos — W02 (inicio) + W07 (Lista + Detalle) + W08 (Escritura)."""
from django.urls import path
from . import views

app_name = 'productos'

urlpatterns = [
    # Inicio (W02)
    path('inicio/', views.index, name='inicio'),

    # Lectura (W07)
    path('',
         views.ProductoListView.as_view(),
         name='lista'),
    path('<int:producto_id>/',
         views.ProductoDetailView.as_view(),
         name='detalle'),

    # Escritura (W08)
    path('nuevo/',
         views.ProductoCreateView.as_view(),
         name='crear'),

    # Pendientes de W08 — descomentar al implementarlas
    # path('<int:producto_id>/editar/',   views.ProductoUpdateView.as_view(), name='editar'),
    # path('<int:producto_id>/eliminar/', views.ProductoDeleteView.as_view(), name='eliminar'),
]