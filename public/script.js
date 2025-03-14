document.addEventListener('DOMContentLoaded', () => {
    const fetchButton = document.getElementById('fetchButton');
    const apiResult = document.getElementById('apiResult');
    const timeButton = document.getElementById('timeButton');
    const timeResult = document.getElementById('timeResult');

    // Fetch API data
    fetchButton.addEventListener('click', async () => {
        try {
            apiResult.textContent = 'Loading...';
            const response = await fetch('/api/hello');
            const data = await response.json();
            apiResult.textContent = JSON.stringify(data, null, 2);
        } catch (error) {
            apiResult.textContent = `Error: ${error.message}`;
        }
    });

    // Fetch server time
    timeButton.addEventListener('click', async () => {
        try {
            timeResult.textContent = 'Loading...';
            const response = await fetch('/api/time');
            const data = await response.json();
            timeResult.textContent = `Server time: ${new Date(data.time).toLocaleString()}`;
        } catch (error) {
            timeResult.textContent = `Error: ${error.message}`;
        }
    });
});