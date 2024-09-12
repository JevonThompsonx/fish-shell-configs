function bunCreateVite
    # Function to check if bun is installed
    function check_bun
        # Check if bun exists
        if type -q bun
            echo "Bun is already installed."
        else
            echo "Bun is not installed. Installing now..."
            # Attempt to install bun
            if curl -fsSL https://bun.sh/install | bash
                echo "Bun installation successful!"
            else
                echo "Bun installation failed. Please check your internet connection or try manually."
                exit 1
            end
        end
    end

    # Call the function to check if bun is installed
    check_bun

    # Check if a project name is provided; otherwise, use default
    if test (count $argv) -gt 0
        set PROJECT_NAME $argv[1]
    else
        set PROJECT_NAME "my-project"
    end

    # Create the Vite project with Vue and TypeScript
    echo "Creating Vite project with Vue and TypeScript..."
    bun create vite $PROJECT_NAME --template vue-ts
    cd $PROJECT_NAME

    # Install dependencies
    echo "Installing dependencies..."
    bun install

    # Install and configure Tailwind CSS
    echo "Installing Tailwind CSS, PostCSS, and Autoprefixer..."
    bun add -d tailwindcss postcss autoprefixer
    bunx tailwindcss init

    echo "Configuring Tailwind CSS..."
    echo "
    module.exports = {
        content: [
            './index.html',
            './src/**/*.{vue,ts,js,jsx,tsx}',
        ],
        theme: {
            extend: {},
        },
        plugins: [],
    }
    " > tailwind.config.js

    echo "Adding Tailwind to main CSS..."
    echo '@tailwind base;' >> src/main.css
    echo '@tailwind components;' >> src/main.css
    echo '@tailwind utilities;' >> src/main.css

    # Update src/main.ts to import the CSS file
    echo "Importing main CSS in main.ts..."
    sed -i '' 's/import App from .\/App.vue/import App from .\/App.vue\nimport .\/main.css/' src/main.ts

    # Install and configure Biome
    echo "Installing Biome..."
    bun add -d biome

    echo "Configuring Biome..."
    echo '{
      "$schema": "https://raw.githubusercontent.com/biomejs/biome/main/schema.json",
      "files": {
        "include": ["src/**/*.{js,ts,vue,css}"]
      },
      "formatter": {
        "enabled": true
      },
      "linter": {
        "rules": {
          "recommended": true
        }
      },
      "organizeImports": {
        "enabled": true
      }
    }' > biome.config.json

    echo "Adding Biome commands to package.json..."
    jq '.scripts += { "format": "bun biome format .", "lint": "bun biome check ." }' package.json | sponge package.json

    # Install and configure the simple router with unplugin-vue-router
    echo "Installing unplugin-vue-router..."
    bun add -d unplugin-vue-router vue-router@next

    # Add the router plugin to vite.config.ts
    echo "Configuring vite.config.ts for unplugin-vue-router..."
    sed -i '' 's/import { defineConfig } from .vite./import { defineConfig } from "vite";\nimport VueRouter from "unplugin-vue-router\/vite";/' vite.config.ts

    echo "Adding VueRouter plugin to vite.config.ts..."
    sed -i '' 's/plugins: \[/plugins: [VueRouter(),/' vite.config.ts

    # Modify src/main.ts to use the router
    echo "Modifying main.ts to use VueRouter..."
    echo 'import { createApp } from "vue"
import App from "./App.vue"
import { createRouter } from "vue-router/auto"
import "./main.css"

const app = createApp(App)
const router = createRouter()
app.use(router)
app.mount("#app")
' > src/main.ts

    # Inform the user
    echo "Setup complete! Project $PROJECT_NAME created with Vite, Vue, TypeScript, Tailwind CSS, and simple routing using unplugin-vue-router."
end