# Tienda de Productos KM!

## Descripción
¡Esto es la Tienda de Productos KM!. Una API para almacenar y gestionar tus productos.

Esta API REST está construida usando Rack en Ruby, sobre una base de datos PostgreSQL y usando el estándar JWT para
el manejo de la autenticación.

Principales características:

- Creación, acceso y gestión de la base de datos usando [PostgreSQL](https://github.com/ged/ruby-pg) y 
[Sequel](https://github.com/jeremyevans/sequel)
- Almacenamiento de contraseñas cifradas en la base de datos con [BCrypt](https://github.com/codahale/bcrypt-ruby)
- Implementación de autenticación basada en token usando [JWT Gem](https://github.com/jwt/ruby-jwt)
- Adición de enpoints para autenticar usuario, obtener todos sus productos, solicitar la creación de un producto y 
hacer seguimiento de dicha solicitud (vea más detalles en el [archivo de especificación OpenAPI del proyecto](https://github.com/kimberlykeilymh/tienda-de-productos-km_api/blob/main/public/openapi.yaml)).
- Compresión de la respuesta del servidor con gzip usando el middleware `Rack::Deflater`.



## Para empezar

Asegúrese de tener instalado Ruby v3.3+ y PostgreSQL.

### Clone el repositorio

```
git clone git@github.com:kimberlykeilymh/tienda-de-productos-km_api.git
cd tienda-de-productos-km_api
```

### Instale las dependencias

```
bundle install
```

Luego de instalar las dependencias debe crear el achivo `.env`, para ello duplique el archivo `.env.example`, 
modifique el nombre y defina los valores `DB_USER`, `DB_PASSWORD`, `DB_NAME` y `JWT_SECRET_KEY`.

```ruby
# .env
DB_ADAPTER=postgres
DB_USER=tu-usuario-postgres
DB_PASSWORD=tu-contraseña-postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tu-base_de_datos-local

JWT_SECRET_KEY=tu-clave-secreta-jwt
JWT_ALGORITHM=HS256
```

### Prepare la base de datos

```
ruby db/seed.rb
```

### Inicie el servidor

```
rackup -p 9292
```
Rackup usará el servidor que tenga instalado en su máquina (WEBrick, thin, Puma, etc.).



## Posibles funcionalidades y características a implementar

Este es un listado de funcionalidades y características que se podrían implementar tomando en cuenta que este es 
un MVP que sirve como base para una API que se espera que crezca en la cantidad datos, recursos, endpoints y usuarios.

- Implementar un sistema de migraciones que permita hacer cambios sobre el esquema de la base de datos de 
forma iterativa y consistente.
- Implementar diferentes ambientes (desarrollo, pruebas y producción) para facilitar el desarrollo y publicación 
de la API.
- Implementar un sistema de enrutamiento que permita agregar de una forma rápida y sencilla rutas y definir 
características para la mismas.
- Implementar el versionamiento de la API desde la cabecera de las peticiones, para permitir futuras mejoras, 
facilidad de mantenimiento y un manejo adecuado del ciclo de vida.
- Implementar Rack CORS para manejar el intercambio de recursos entre orígenes.
- Limitar la cantidad de peticiones que puede hacer un cliente para evitar ataques de terceros.
- Agregar validación del formato de contraseñas para mejorar la seguridad desde el usuario.
- Implementar un mecanismo de expiración de tokens por ID más allá del campo `exp`.
- Agregar `UUID` en los modelos y rutas para proteger la API contra ataque por predicción de identificadores.
- Validar el contenido de las cabeceras `Accept` y `Content-Type`.
- Agregar paginación a endpoints que puedan manejar una gran cantidad de datos (por ejemplo: `GET /products`).
- Implementar pruebas que permitan verificar el correcto funcionamiento de la API en cualquier momento.
- Implementar un registro (log) adecuado de transacciones para el seguimiento del comportamiento de la aplicación 
en los diferentes ambientes.
