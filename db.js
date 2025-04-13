const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./output/DPM_OUT_SAN_graph.db');

db.serialize(() => {
    // Créez une table si elle n'existe pas
    db.run("CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, name TEXT, email TEXT)");

    // Insérez des données
    const stmt = db.prepare("INSERT INTO user (name, email) VALUES (?, ?)");
    stmt.run("Alice", "alice@example.com");
    stmt.run("Bob", "bob@example.com");
    stmt.finalize();

    // Interrogez les données
    db.each("SELECT id, name, email FROM user", (err, row) => {
        if (err) {
            console.error(err.message);
        }
        console.log(`${row.id}: ${row.name}, ${row.email}`);
    });
});

db.close();
