const http = require('http');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

const PORT = 3000;
const BINARY = path.join(__dirname, 'tasklang');

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  if (req.method === 'POST' && req.url === '/run') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const { code } = JSON.parse(body);
        if (!code) { res.writeHead(400); res.end(JSON.stringify({ error: 'No code provided' })); return; }

        const tmpFile = path.join(os.tmpdir(), 'tasklang_' + Date.now() + '.tl');
        fs.writeFileSync(tmpFile, code);

        exec(BINARY + ' ' + tmpFile, (err, stdout, stderr) => {
          fs.unlinkSync(tmpFile);
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({
            stdout: stdout || '',
            stderr: stderr || '',
            exitCode: err ? err.code : 0
          }));
        });
      } catch (e) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: e.message }));
      }
    });
    return;
  }

  res.writeHead(404); res.end();
});

server.listen(PORT, () => {
  console.log('');
  console.log('  TaskLang++ Server running at http://localhost:' + PORT);
  console.log('  POST /run  →  runs your .tl code through the parser');
  console.log('  Keep this terminal open while using the UI.');
  console.log('');
});
