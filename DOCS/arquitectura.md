# 🏗️ Arquitectura del Sistema - SIGAUT

## 📋 Introducción
El sistema **SIGAUT** adopta una arquitectura **cliente-servidor**, con un **frontend móvil en Flutter** siguiendo el patrón **MVVM** y un **backend en Spring Boot** bajo el modelo de **API RESTful**. Esta elección se fundamenta en la necesidad de garantizar escalabilidad, modularidad, seguridad y facilidad de mantenimiento en un sistema de gestión de abarrotes.

---

## 🌐 Cliente-Servidor
La separación entre cliente y servidor permite:
- **Escalabilidad**: el backend puede evolucionar de forma independiente al frontend.
- **Flexibilidad**: el sistema puede ser consumido por múltiples clientes (móvil, web, escritorio).
- **Mantenibilidad**: la lógica de negocio se concentra en el backend, evitando duplicidad en el cliente.

---

## 📱 Frontend - Flutter con MVVM
El uso de **Flutter** en combinación con **MVVM (Model-View-ViewModel)** proporciona:
- **Interfaz consistente y reactiva**: permite ofrecer una experiencia de usuario fluida en dispositivos Android e iOS.
- **Separación de responsabilidades**: el patrón MVVM asegura que la interfaz de usuario (View) se mantenga desacoplada de la lógica de negocio (ViewModel).
- **Reutilización de componentes**: facilita pruebas unitarias y la integración continua.
- **Multiplataforma**: una sola base de código para distintas plataformas reduce costos de desarrollo y mantenimiento.

---

## ⚙️ Backend - Spring Boot
El backend está construido con **Spring Boot** debido a sus ventajas:
- **API RESTful**: garantiza interoperabilidad entre sistemas y estandarización en el consumo de servicios.
- **Gestión de seguridad**: se implementa **Spring Security** con **JWT** para autenticación y autorización robusta.
- **Integración con bases de datos**: el uso de **JPA/Hibernate** permite abstracción y eficiencia en el manejo de datos relacionales.
- **Escalabilidad y modularidad**: la arquitectura basada en controladores, servicios y repositorios promueve una separación clara de capas.

---

## 🗄️ Base de Datos Relacional
Se opta por **MySQL/PostgreSQL** como base de datos relacional debido a:
- **Fiabilidad y consistencia**: cumplen con las propiedades **ACID**, esenciales en procesos de inventario y ventas.
- **Soporte maduro**: cuentan con herramientas y documentación amplia.
- **Escalabilidad vertical y horizontal**: permiten crecimiento conforme aumente la demanda del sistema.

---

## 🔐 Seguridad
La arquitectura incorpora mecanismos de seguridad integrados:
- **JWT** para autenticación basada en tokens.
- **Spring Security** para autorización por roles.
- **Validación de datos** en frontend y backend.
- **Separación de responsabilidades** que minimiza riesgos de acceso no autorizado.

---

## 📊 Beneficios Clave
- **Escalabilidad**: posibilidad de crecimiento sin afectar la estabilidad del sistema.
- **Mantenibilidad**: estructura modular que facilita incorporación de nuevas funcionalidades.
- **Interoperabilidad**: integración con otros sistemas gracias a REST y estándares abiertos.
- **Experiencia de usuario mejorada**: interfaz móvil intuitiva y validaciones en tiempo real.
- **Confiabilidad**: el uso de frameworks probados (Flutter y Spring Boot) reduce riesgos en producción.

---

## ✅ Conclusión
La arquitectura seleccionada en **SIGAUT** combina lo mejor de las tecnologías modernas para aplicaciones móviles y servicios backend. La integración de **Flutter con MVVM** en el cliente, junto con **Spring Boot y una base de datos relacional** en el servidor, garantiza un sistema seguro, escalable y eficiente, capaz de satisfacer las necesidades de gestión de abarrotes de manera profesional y sostenible en el tiempo.
