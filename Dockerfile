# 1. Sistema operativo base
FROM ubuntu:22.04

# 2. Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# 3. Actualizar e instalar dependencias (Agregadas librerías de criptografía)
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    pkg-config \
    libncurses5-dev \
    uuid-dev \
    libjansson-dev \
    libxml2-dev \
    sqlite3 \
    libsqlite3-dev \
    libedit-dev \
    libssl-dev \
    libsrtp2-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. Carpeta de trabajo temporal
WORKDIR /usr/src

# 5. Descargar, extraer, limpiar y renombrar la carpeta a un nombre estático
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz \
    && tar -zxvf asterisk-20-current.tar.gz \
    && rm asterisk-20-current.tar.gz \
    && mv asterisk-20.* asterisk-20

# 6. Entrar a la carpeta exacta
WORKDIR /usr/src/asterisk-20

# 7. Configurar, compilar e instalar Asterisk
RUN ./configure \
    && make \
    && make install

VOLUME ["/etc/asterisk"]

# 8. Comando por defecto para mantener Asterisk corriendo en primer plano
CMD ["asterisk", "-vvvdddf", "-c"]
