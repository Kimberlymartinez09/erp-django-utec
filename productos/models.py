# productos/models.py
"""Modelos de la app productos — Espiral 2 W05, actualizado en W11 (imagen)."""
from decimal import Decimal

from django.core.exceptions import ValidationError
from django.core.validators import MinValueValidator
from django.db import models

from proveedores.models import Proveedor
from .validators import validar_imagen_producto


class Categoria(models.Model):
    """Categoría para clasificar productos del catálogo.

    Atributos:
        nombre:      Nombre único de la categoría.
        descripcion: Descripción opcional.
    """

    nombre      = models.CharField(
        max_length=100, unique=True, verbose_name='Nombre'
    )
    descripcion = models.TextField(
        blank=True, verbose_name='Descripción'
    )

    class Meta:
        verbose_name        = 'Categoría'
        verbose_name_plural = 'Categorías'
        ordering            = ['nombre']

    def __str__(self) -> str:
        return self.nombre


class Producto(models.Model):
    """Producto del catálogo.

    Atributos:
        nombre:    Nombre del producto.
        precio:    Precio unitario, no negativo.
        stock:     Unidades disponibles, no negativas.
        categoria: Categoría (no se puede borrar si tiene productos).
        proveedor: Proveedor opcional.
        activo:    Indica si el producto se muestra en el catálogo.
        imagen:    Imagen opcional del producto (W11).
        creado:    Fecha de registro.
    """

    nombre    = models.CharField(
        max_length=200, verbose_name='Nombre'
    )
    precio    = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(Decimal('0.00'))],
        verbose_name='Precio ($)',
        help_text='El precio no puede ser negativo.'
    )
    stock     = models.IntegerField(
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name='Stock disponible'
    )
    categoria = models.ForeignKey(
        Categoria,
        on_delete=models.PROTECT,          # no borrar categoría con productos
        related_name='productos',
        verbose_name='Categoría'
    )
    proveedor = models.ForeignKey(
        Proveedor,
        on_delete=models.SET_NULL,         # el producto puede quedar sin proveedor
        null=True,
        blank=True,
        related_name='productos',
        verbose_name='Proveedor'
    )
    activo    = models.BooleanField(
        default=True, verbose_name='Activo'
    )
    imagen    = models.ImageField(
        upload_to='productos/',            # subcarpeta dentro de MEDIA_ROOT
        null=True,
        blank=True,
        verbose_name='Imagen del producto',
        help_text='Formatos permitidos: JPEG, PNG, WEBP. Máximo 5 MB.',
        validators=[validar_imagen_producto],
    )
    creado    = models.DateTimeField(
        auto_now_add=True, verbose_name='Fecha de registro'
    )

    class Meta:
        verbose_name        = 'Producto'
        verbose_name_plural = 'Productos'
        ordering            = ['nombre']

    def __str__(self) -> str:
        return f"{self.nombre} (${self.precio:.2f})"

    def clean(self) -> None:
        """Validaciones de negocio cruzadas para Producto.

        Ejecutadas por full_clean() (formularios y llamadas explícitas).
        No se ejecutan con save() directo.

        Raises:
            ValidationError: si precio < 0 o stock < 0.
        """
        errors = {}

        if self.precio is not None and self.precio < 0:
            errors['precio'] = (
                'El precio no puede ser negativo. '
                f'Valor recibido: {self.precio}'
            )

        if self.stock is not None and self.stock < 0:
            errors['stock'] = (
                'El stock no puede ser negativo. '
                f'Valor recibido: {self.stock}'
            )

        if errors:
            raise ValidationError(errors)