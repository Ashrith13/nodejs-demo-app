Node.js CI/CD Demo App with GitHub Actions and Docker

This project demonstrates a full **CI/CD pipeline** for a sample **Node.js** application using **GitHub Actions** and **DockerHub**. It automatically builds, tests, containerizes, and deploys the app when code is pushed to the `main` branch.

Project Objectives

- Create a simple **Node.js + Express** web app.
- Package the app into a **Docker container**.
- Use **GitHub Actions** to automate:
  - Code checkout
  - Dependency installation
  - Running tests
  - Building the Docker image
  - Logging in to DockerHub
  - Pushing the image to DockerHub
- Trigger the workflow **automatically** on pushes to the `main` branch.

---

Project Structure


nodejs-demo-app/
│
├── index.js                  # Main application file
├── package.json              # Node.js dependencies and scripts
├── Dockerfile                # Instructions to build the Docker image
└── .github/
└── workflows/
└── main.yml          # GitHub Actions CI/CD workflow


Setup Instructions:

1️⃣ Set up the Node.js App

```bash
mkdir nodejs-demo-app && cd nodejs-demo-app
npm init -y
npm install express
````

Create a file named `index.js`:

```js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello from CI/CD pipeline!');
});

app.listen(port, () => {
  console.log(`App running on http://localhost:${port}`);
});
```

Update your `package.json`:

```json
"scripts": {
  "start": "node index.js",
  "test": "echo \"No tests yet\" && exit 0"
}
```

Run locally to test:

```bash
node index.js
```

Open in browser: [http://localhost:3000](http://localhost:3000)

---

2️⃣ Create the Dockerfile

Create a file named `Dockerfile` in the root:

```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

To build and test it locally:

```bash
docker build -t nodejs-demo-app .
docker run -p 3000:3000 nodejs-demo-app
```

---

3️⃣ Push to GitHub

1. Create a new repository on GitHub (e.g., `nodejs-demo-app`)
2. Push your code:

```bash
git init
git remote add origin https://github.com/yourusername/nodejs-demo-app.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

---

4️⃣ Configure GitHub Actions Workflow

Create the workflow file:

```bash
mkdir -p .github/workflows
touch .github/workflows/main.yml
```

Paste the following into `.github/workflows/main.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Run tests
      run: npm test

    - name: Build Docker image
      run: docker build -t ${{ secrets.DOCKER_USERNAME }}/nodejs-demo-app .

    - name: Login to DockerHub
      run: echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin

    - name: Push Docker image
      run: docker push ${{ secrets.DOCKER_USERNAME }}/nodejs-demo-app
```

---

5️⃣ Set Up DockerHub

1. Create a [DockerHub](https://hub.docker.com) account.
2. Create a **public repository** named `nodejs-demo-app`.
3. Add **GitHub secrets**:

   * Go to your GitHub repo > **Settings** > **Secrets and Variables** > **Actions**
   * Add:

     * `DOCKER_USERNAME` → your DockerHub username
     * `DOCKER_PASSWORD` → your DockerHub password or access token

---

6️⃣ Trigger and Verify the Workflow

Commit and push the workflow file:

```bash
git add .github/workflows/main.yml
git commit -m "Add CI/CD GitHub Actions workflow"
git push
```

✅ Go to the **Actions** tab in GitHub to track the workflow progress.

---

7️⃣ Validate Deployment

After the workflow completes:

* ✅ Check DockerHub → Your image `nodejs-demo-app` should be listed.
* ✅ You can pull and run it from anywhere:

```bash
docker pull your-dockerhub-username/nodejs-demo-app
docker run -p 3000:3000 your-dockerhub-username/nodejs-demo-app
```

Visit: [http://localhost:3000](http://localhost:3000)

---

Summary:

You've successfully:

* ✅ Created a basic Node.js app with Express
* ✅ Dockerized your application
* ✅ Built and deployed a CI/CD pipeline using GitHub Actions
* ✅ Automatically pushed Docker images to DockerHub on `main` branch updates

---

