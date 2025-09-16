#!/bin/bash
# Script para rodar o backend com Docker

echo "Construindo a imagem Docker..."
docker build -t backend-app .

echo "Rodando o container na porta 8055..."
docker run -p 8055:8055 backend-app
