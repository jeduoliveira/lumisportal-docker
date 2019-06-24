Lumis Experience Platform 11.2.0.190404
=====================

[![Docker Pulls](https://img.shields.io/docker/pulls/jeduoliveira/lumisportal-stack.svg)](https://cloud.docker.com/u/jeduoliveira/repository/docker/jeduoliveira/lumisportal-stack)

O que é ?
---------

O LumisXP (Lumis Experience Platform) é uma plataforma para a criação e gestão de soluções para a experiência digital do cliente.

Utilizada por grandes empresas dos mais variados segmentos de mercado, a plataforma conta com diversos recursos que ajudam as empresas a acelerar a transformação digital dos seus negócios. As funcionalidades do LumisXP permitem que você desenvolva os canais digitais da sua empresa, colocando o seu cliente como elemento central da solução.

Dependências
------------
O [LumisXP](https://lumisxp.lumis.com.br/) depende de alguns softwares para seu pleno funcionamento. É necessário ter instalado um [elasticsearch](https://www.elastic.co/pt/products/elasticsearch), [apache](https://httpd.apache.org/) / [nginx](https://www.nginx.com/) e um banco de dados, iremos utilizar o [MySQL](https://www.mysql.com/).

A stack completa
----------------
Para executar a stack completa utilizei o docker-compose.

Segue o github com o docker-compose.yml 
[github](https://github.com/jeduoliveira/lumisportal-docker-compose-11.2.0)

Considerações
-------------

Portas que podem ser expostas

    EXPOSE 8080
    EXPOSE 8009