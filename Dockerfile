FROM node:18

# diretório de trabalho
WORKDIR /app

# copiar package.json e instalar dependências
COPY package*.json ./
RUN npm install

# copiar restante
COPY . .

# expor porta
EXPOSE 8055

# rodar Directus
CMD ["npm", "run", "dev"]
