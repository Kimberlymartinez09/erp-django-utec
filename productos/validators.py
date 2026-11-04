# productos/validators.py
"""Validadores de archivos de imagen para la app productos — W11.

Valida:
    - Que el archivo sea realmente una imagen (Pillow + filetype)
    - Que el formato sea JPEG, PNG o WEBP
    - Que el tamaño no supere MAX_IMAGE_SIZE
"""
import filetype
from PIL import Image, UnidentifiedImageError

from django.core.exceptions import ValidationError


# Tamaño máximo permitido: 5 MB
MAX_IMAGE_SIZE = 5 * 1024 * 1024   # 5,242,880 bytes

# Formatos de imagen aceptados
FORMATOS_MIME_PERMITIDOS = {'image/jpeg', 'image/png', 'image/webp'}


def validar_imagen_producto(archivo) -> None:
    """Valida un archivo subido como imagen de producto.

    Verificaciones realizadas (en orden):
        1. Tamaño máximo 5 MB.
        2. Tipo MIME real (magic bytes) es image/jpeg, image/png o image/webp.
        3. El contenido puede abrirse con Pillow (imagen no corrupta).

    Raises:
        ValidationError: si alguna verificación falla.
    """
    # 1. Tamaño
    if archivo.size > MAX_IMAGE_SIZE:
        raise ValidationError(
            f'La imagen supera el tamaño máximo permitido de 5 MB. '
            f'Tamaño recibido: {archivo.size / (1024 * 1024):.1f} MB.'
        )

    # 2. Tipo MIME desde magic bytes (no confiar en la extensión)
    archivo.seek(0)
    cabecera = archivo.read(512)
    archivo.seek(0)

    tipo = filetype.guess(cabecera)
    if tipo is None or tipo.mime not in FORMATOS_MIME_PERMITIDOS:
        mime_detectado = tipo.mime if tipo else 'desconocido'
        raise ValidationError(
            f'Tipo de archivo no permitido: {mime_detectado}. '
            f'Solo se aceptan: JPEG, PNG, WEBP.'
        )

    # 3. Pillow puede abrir la imagen (no corrupta)
    archivo.seek(0)
    try:
        img = Image.open(archivo)
        img.verify()
    except (UnidentifiedImageError, Exception) as exc:
        raise ValidationError(
            f'El archivo no es una imagen válida o está corrupto: {exc}'
        )
    finally:
        archivo.seek(0)