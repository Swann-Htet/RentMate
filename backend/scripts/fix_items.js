const mysql = require('mysql2/promise');
(async () => {
  const c = await mysql.createConnection({
    host: 'db', user: 'root', password: 'rootpassword', database: 'rentmate'
  });
  try { await c.query("ALTER TABLE items ADD COLUMN approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending'"); } catch(e) { console.log(e.message) }
  try { await c.query("ALTER TABLE items ADD COLUMN approval_date TIMESTAMP NULL"); } catch(e) { console.log(e.message) }
  try { await c.query("ALTER TABLE items ADD COLUMN is_active BOOLEAN DEFAULT true"); } catch(e) { console.log(e.message) }
  console.log('Done altering items table.');
  process.exit(0);
})();