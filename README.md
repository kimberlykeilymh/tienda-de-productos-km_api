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
