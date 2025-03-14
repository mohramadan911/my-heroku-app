# Heroku Sample Web App

A simple web application built with Node.js and Express, ready for deployment on Heroku.

## Local Development

1. Make sure you have [Node.js](https://nodejs.org/) installed (version 18.x or later recommended)

2. Clone this repository
   ```
   git clone <your-repo-url>
   cd heroku-sample-app
   ```

3. Install dependencies
   ```
   npm install
   ```

4. Start the development server
   ```
   npm run dev
   ```

5. Visit `http://localhost:3000` in your browser

## Heroku Deployment

1. Make sure you have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed

2. Login to Heroku
   ```
   heroku login
   ```

3. Create a new Heroku app
   ```
   heroku create your-app-name
   ```

4. Deploy to Heroku
   ```
   git push heroku main
   ```

5. Open your deployed app
   ```
   heroku open
   ```

## Project Structure

- `app.js` - Main server file with Express configuration
- `public/` - Static files directory
  - `index.html` - Main HTML file
  - `styles.css` - CSS styles
  - `script.js` - Frontend JavaScript

## Features

- Simple API endpoints
- Server-side rendering
- Static file serving
- Environment variable configuration
- Responsive design
